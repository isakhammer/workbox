# Source this file in Bash so Ranger can change the calling shell's directory.
unalias r 2>/dev/null || true

if [[ -d "$HOME/.local/bin" ]]; then
    case ":$PATH:" in
        *":$HOME/.local/bin:"*) ;;
        *) export PATH="$HOME/.local/bin:$PATH" ;;
    esac
fi

function r() {
    local ranger_choice ranger_status ranger_directory
    ranger_choice=$(mktemp "${TMPDIR:-/tmp}/ranger-cwd.XXXXXX") || return

    command ranger --choosedir="$ranger_choice" "$@"
    ranger_status=$?
    if [[ "$ranger_status" -eq 0 && -s "$ranger_choice" ]]; then
        ranger_directory=$(<"$ranger_choice")
        if [[ -d "$ranger_directory" ]]; then
            builtin cd -- "$ranger_directory" || ranger_status=$?
        fi
    fi
    command rm -f -- "$ranger_choice"
    return "$ranger_status"
}
