CHECK_INTERVAL=$((6 * 60 * 60))
CHECK_STAMP="${HOME}/.cache/devcontainer-repo-update-check"

REPO="$(git rev-parse --show-toplevel 2>/dev/null)" || return 0

REMOTE="origin"

# Throttle remote checks.
NOW="$(date +%s)"

if [ -f "$CHECK_STAMP" ]; then
    LAST_CHECK="$(cat "$CHECK_STAMP" 2>/dev/null || echo 0)"

    if (( NOW - LAST_CHECK < CHECK_INTERVAL )); then
        return 0
    fi
fi

printf '%s\n' "$NOW" > "$CHECK_STAMP"

# Discover the remote's current default branch.
DEFAULT_REF="$(
    git -C "$REPO" ls-remote --symref "$REMOTE" HEAD 2>/dev/null |
    awk '$1 == "ref:" { print $2; exit }'
)"

[ -n "$DEFAULT_REF" ] || return 0

DEFAULT_BRANCH="${DEFAULT_REF#refs/heads/}"

# Get the current SHA of the remote default branch directly from the remote.
REMOTE_SHA="$(
    git -C "$REPO" ls-remote "$REMOTE" \
        "refs/heads/${DEFAULT_BRANCH}" 2>/dev/null |
    awk 'NR == 1 { print $1 }'
)"

[ -n "$REMOTE_SHA" ] || return 0

# Get the last known SHA of the default branch in this clone.
LOCAL_REMOTE_SHA="$(
    git -C "$REPO" rev-parse \
        "refs/remotes/${REMOTE}/${DEFAULT_BRANCH}" 2>/dev/null
)" || return 0

# Nothing new.
[ "$LOCAL_REMOTE_SHA" = "$REMOTE_SHA" ] && return 0

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
        echo

        CURRENT_BRANCH="$(
            git -C "$REPO" branch --show-current 2>/dev/null
        )"

        if [ "$CURRENT_BRANCH" = "$DEFAULT_BRANCH" ]; then
            git -C "$REPO" pull --ff-only "$REMOTE" "$DEFAULT_BRANCH"
        else
            echo "You are currently on branch '${CURRENT_BRANCH}'."
            echo "The default branch '${DEFAULT_BRANCH}' has an update."
            echo
            echo "Not pulling automatically to avoid merging"
            echo "'${DEFAULT_BRANCH}' into '${CURRENT_BRANCH}'."
        fi
        ;;
    *)
        echo "Skipping update."
        ;;
esac

echo