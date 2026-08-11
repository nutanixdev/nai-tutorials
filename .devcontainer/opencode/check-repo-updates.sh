# Discover the remote's default branch.
DEFAULT_REF="$(
    git -C "$REPO" ls-remote --symref "$REMOTE" HEAD 2>/dev/null |
    awk '$1 == "ref:" { print $2; exit }'
)"

[ -n "$DEFAULT_REF" ] || return 0

DEFAULT_BRANCH="${DEFAULT_REF#refs/heads/}"

# Local default branch SHA.
LOCAL_SHA="$(
    git -C "$REPO" rev-parse \
        "refs/heads/${DEFAULT_BRANCH}" 2>/dev/null
)" || return 0

# Actual remote default branch SHA.
REMOTE_SHA="$(
    git -C "$REPO" ls-remote "$REMOTE" \
        "refs/heads/${DEFAULT_BRANCH}" 2>/dev/null |
    awk 'NR == 1 { print $1 }'
)"

[ -n "$REMOTE_SHA" ] || return 0

# Already up to date.
[ "$LOCAL_SHA" = "$REMOTE_SHA" ] && return 0

echo
echo "────────────────────────────────────────────────────"
echo " A newer version of this repository is available."
echo
echo " Default branch: ${DEFAULT_BRANCH}"
echo "────────────────────────────────────────────────────"
echo

read -r -p "Update now? [y/N] " ANSWER

case "$ANSWER" in
    y|Y|yes|YES)
        git -C "$REPO" pull --ff-only "$REMOTE" "$DEFAULT_BRANCH"
        ;;
    *)
        echo "Skipping update."
        ;;
esac

echo