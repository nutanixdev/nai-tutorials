#!/usr/bin/env bash
set -euo pipefail

readonly EXPECTED_USER="nutanix"
readonly EXPECTED_UID="1000"
readonly EXPECTED_GID="1000"
readonly ROOT_BLOCKER="/usr/local/sbin/block-root-login"

echo "Applying locked-down devcontainer security controls..."

if [[ "$(id -u)" -ne 0 ]]; then
    echo "ERROR: apply-security.sh must run as root during the image build."
    exit 1
fi

if ! id "${EXPECTED_USER}" >/dev/null 2>&1; then
    echo "ERROR: Required user '${EXPECTED_USER}' does not exist."
    exit 1
fi

actual_uid="$(id -u "${EXPECTED_USER}")"
actual_gid="$(id -g "${EXPECTED_USER}")"

if [[ "${actual_uid}" != "${EXPECTED_UID}" ]]; then
    echo "ERROR: ${EXPECTED_USER} UID is ${actual_uid}; expected ${EXPECTED_UID}."
    exit 1
fi

if [[ "${actual_gid}" != "${EXPECTED_GID}" ]]; then
    echo "ERROR: ${EXPECTED_USER} GID is ${actual_gid}; expected ${EXPECTED_GID}."
    exit 1
fi

echo "Installing interactive root-login guard..."

install -d -m 0755 /usr/local/sbin

cat > "${ROOT_BLOCKER}" <<'EOF'
#!/usr/bin/env bash

printf '%s\n' \
    "Security policy violation: interactive root login is disabled." \
    "This development environment must run as the 'nutanix' user."

exit 126
EOF

chown root:root "${ROOT_BLOCKER}"
chmod 0755 "${ROOT_BLOCKER}"

# Register the blocker as a valid shell.
if [[ -f /etc/shells ]] && ! grep -Fxq "${ROOT_BLOCKER}" /etc/shells; then
    printf '%s\n' "${ROOT_BLOCKER}" >> /etc/shells
fi

# Change root's configured login shell without relying on chsh.
awk -F: -v OFS=: -v shell="${ROOT_BLOCKER}" '
    $1 == "root" {
        $7 = shell
    }

    {
        print
    }
' /etc/passwd > /etc/passwd.hardened

chown root:root /etc/passwd.hardened
chmod 0644 /etc/passwd.hardened
mv /etc/passwd.hardened /etc/passwd

echo "Removing privilege and account-management utilities..."

privilege_tools=(
    /usr/bin/sudo
    /usr/bin/sudoedit
    /usr/local/bin/sudo
    /usr/local/bin/sudoedit

    /usr/bin/su
    /bin/su

    /usr/bin/passwd
    /usr/bin/chfn
    /usr/bin/chsh
    /usr/bin/gpasswd
    /usr/bin/chage
    /usr/bin/expiry
    /usr/bin/newgrp
)

for file in "${privilege_tools[@]}"; do
    if [[ -e "${file}" || -L "${file}" ]]; then
        echo "Removing ${file}"
        rm -f -- "${file}"
    fi
done

# Clear the shell command cache in case a removed executable was cached.
hash -r 2>/dev/null || true

echo "Removing setuid and setgid privilege bits..."

declare -a search_paths=()

for directory in /usr/bin /usr/sbin /bin /sbin; do
    if [[ -d "${directory}" ]]; then
        search_paths+=("${directory}")
    fi
done

if (( ${#search_paths[@]} > 0 )); then
    find "${search_paths[@]}" \
        -xdev \
        -type f \
        \( -perm -4000 -o -perm -2000 \) \
        -exec chmod a-s {} +
fi

echo "Locking system policy files..."

if [[ -f /etc/opencode/opencode.jsonc ]]; then
    chown root:root /etc/opencode/opencode.jsonc
    chmod 0444 /etc/opencode/opencode.jsonc
else
    echo "ERROR: /etc/opencode/opencode.jsonc does not exist."
    exit 1
fi

# Root's home should not be usable by the non-root development user.
chown root:root /root
chmod 0700 /root

echo "Validating hardened image..."

configured_root_shell="$(
    awk -F: '$1 == "root" { print $7 }' /etc/passwd
)"

if [[ "${configured_root_shell}" != "${ROOT_BLOCKER}" ]]; then
    echo "ERROR: Root shell was not set to ${ROOT_BLOCKER}."
    exit 1
fi

for file in \
    /usr/bin/sudo \
    /usr/bin/sudoedit \
    /usr/local/bin/sudo \
    /usr/local/bin/sudoedit \
    /usr/bin/su \
    /bin/su \
    /usr/bin/passwd \
    /usr/bin/chfn \
    /usr/bin/chsh \
    /usr/bin/gpasswd \
    /usr/bin/chage \
    /usr/bin/expiry \
    /usr/bin/newgrp
do
    if [[ -e "${file}" || -L "${file}" ]]; then
        echo "ERROR: Privilege-related executable remains: ${file}"
        exit 1
    fi
done

remaining_privileged_files="$(
    find "${search_paths[@]}" \
        -xdev \
        -type f \
        \( -perm -4000 -o -perm -2000 \) \
        -print
)"

if [[ -n "${remaining_privileged_files}" ]]; then
    echo "ERROR: Unexpected setuid/setgid executables remain:"
    printf '%s\n' "${remaining_privileged_files}"
    exit 1
fi

privileged_groups="$(
    id -nG "${EXPECTED_USER}" \
        | tr ' ' '\n' \
        | grep -E '^(root|sudo|wheel|docker|podman|lxd|libvirt)$' \
        || true
)"

if [[ -n "${privileged_groups}" ]]; then
    echo "ERROR: ${EXPECTED_USER} belongs to privileged groups:"
    printf '%s\n' "${privileged_groups}"
    exit 1
fi

if [[ "$(stat -c '%U:%G' /etc/opencode/opencode.jsonc)" != "root:root" ]]; then
    echo "ERROR: OpenCode policy is not owned by root."
    exit 1
fi

if [[ "$(stat -c '%a' /etc/opencode/opencode.jsonc)" != "444" ]]; then
    echo "ERROR: OpenCode policy permissions are not 0444."
    exit 1
fi

echo "Security hardening completed successfully."