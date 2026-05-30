# temux — workstation driver for forge-shell tmux sessions (ADR-0001 §4)
#
# Pairs with `temux-host` on the VPS. Git is the only sync channel.
# Repo: https://github.com/chervince/temux
#
# Note: no shebang and no `set` line here — pkgs.writeShellApplication injects
# `#!/usr/bin/env bash` + `set -o errexit -o nounset -o pipefail` automatically.

readonly SSH_HOST="vincent@forge-shell.neithforge.dev"
readonly SSH_KEY="$HOME/.ssh/neith-forge"

ssh_vps() {
    ssh -i "$SSH_KEY" -o StrictHostKeyChecking=accept-new "$SSH_HOST" "$@"
}

ssh_vps_tty() {
    ssh -i "$SSH_KEY" -o StrictHostKeyChecking=accept-new -t "$SSH_HOST" "$@"
}

usage() {
    cat <<'EOF'
temux — workstation driver for forge-shell tmux sessions

USAGE:
    temux run <project> [-- <cmd...>] [--no-notify] [--allow-dirty]
        Git sync (push from workstation, pull on VPS) then start a tmux
        session on the VPS via temux-host run.
          - default cmd: `claude` (interactive, claude's own hooks notify)
          - with -- <cmd...>: arbitrary command, wrapped by _temux-notify
        Refuses if cwd worktree is dirty (override: --allow-dirty pushes HEAD,
        uncommitted changes stay local).
        After successful push, places ~/.git/temux-elsewhere marker and
        installs pre-commit + post-merge git hooks (idempotent).

    temux attach <project>
        ssh -t into forge-shell and attach to tmux session <project>.

    temux --help
        Show this help.

ARGS:
    <project>  Optional. Inferred from cwd's git toplevel basename if omitted.
               Must match the VPS path: ~/projects/<project>.

EXAMPLES:
    temux run                                  # cwd is acme-api → run claude
    temux run -- bash scripts/orchestrate.sh   # pipeline mode (notified on exit)
    temux run other-repo --allow-dirty         # push HEAD only, ignore WIP
    temux attach acme-api                      # observe from any tab
EOF
}

die() { printf "temux: %s\n" "$*" >&2; exit 1; }

require_git_worktree() {
    git rev-parse --show-toplevel >/dev/null 2>&1 \
        || die "not in a git worktree (cd into one before running temux)"
}

infer_project() {
    local toplevel
    toplevel=$(git rev-parse --show-toplevel 2>/dev/null) || return 1
    basename "$toplevel"
}

# Install hooks (pre-commit warn, post-merge auto-clean) idempotently.
# Only installs OUR hooks; if a custom hook exists, refuse rather than overwrite.
install_hooks() {
    local hooks_dir
    hooks_dir=$(git rev-parse --git-path hooks)

    local pre="$hooks_dir/pre-commit"
    local post="$hooks_dir/post-merge"

    if [[ -f "$pre" ]] && ! grep -q "# temux-managed" "$pre"; then
        printf "temux: ⚠ %s exists and is not temux-managed; skipping install.\n" "$pre" >&2
        printf "       merge manually if you want the marker warning.\n" >&2
    elif [[ ! -f "$pre" ]]; then
        cat > "$pre" <<'HOOK'
#!/usr/bin/env bash
# temux-managed: warn if this project is active on the VPS (ADR-0001 §6)
git_dir="$(git rev-parse --git-dir)"
marker="$git_dir/temux-elsewhere"
if [[ -f "$marker" ]]; then
    {
        echo ""
        echo "⚠  This project is marked active on the VPS:"
        echo "     $(cat "$marker")"
        echo "   Editing the workstation copy may diverge from the VPS state."
        echo "   To proceed anyway:  git commit --no-verify"
        echo "   To reclaim:         git pull   (post-merge clears the marker)"
        echo ""
    } >&2
    exit 1
fi
HOOK
        chmod +x "$pre"
    fi

    if [[ -f "$post" ]] && ! grep -q "# temux-managed" "$post"; then
        printf "temux: ⚠ %s exists and is not temux-managed; skipping install.\n" "$post" >&2
    elif [[ ! -f "$post" ]]; then
        cat > "$post" <<'HOOK'
#!/usr/bin/env bash
# temux-managed: clear "active on VPS" marker after pull (ADR-0001 §6)
rm -f "$(git rev-parse --git-dir)/temux-elsewhere"
HOOK
        chmod +x "$post"
    fi
}

place_marker() {
    local project="$1"
    local marker
    marker="$(git rev-parse --git-dir)/temux-elsewhere"
    printf "active on VPS since %s (project: %s)\n" \
        "$(date -Iseconds)" "$project" > "$marker"
}

cmd_run() {
    local project="" allow_dirty=0 no_notify=0
    local -a passthrough=()
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --allow-dirty) allow_dirty=1; shift ;;
            --no-notify)   no_notify=1;   shift ;;
            --)            shift; passthrough=("$@"); break ;;
            -*)            die "run: unknown flag '$1'. See: temux --help" ;;
            *)             if [[ -z "$project" ]]; then
                               project="$1"
                           else
                               die "run: extra positional arg '$1'"
                           fi
                           shift ;;
        esac
    done

    require_git_worktree
    [[ -n "$project" ]] || project=$(infer_project) \
        || die "run: cannot infer project name; pass it explicitly"

    # check clean unless --allow-dirty
    if [[ $allow_dirty -eq 0 ]]; then
        if [[ -n "$(git status --porcelain)" ]]; then
            die "run: worktree dirty. Commit, stash, or pass --allow-dirty
       (--allow-dirty pushes HEAD only; uncommitted changes stay local)"
        fi
    fi

    # push (refuses if no upstream — user's responsibility to set it)
    printf "temux: pushing %s...\n" "$(git rev-parse --abbrev-ref HEAD)"
    git push

    # auto-init project on VPS if not present (first run on this project)
    if ! ssh_vps "test -d ~/projects/$project/.git"; then
        printf "temux: %s not on VPS yet — auto-init from local 'origin' remote...\n" "$project"
        local remote_url
        if ! remote_url=$(git remote get-url origin 2>/dev/null); then
            die "run: no 'origin' remote on local repo, cannot auto-init.
       Set one (git remote add origin <url>) or init manually:
         ssh -i ~/.ssh/neith-forge vincent@forge-shell.neithforge.dev \\
             temux-host init <url>"
        fi
        # convert HTTPS → SSH for known providers (VPS auths via id_ed25519_temux SSH key)
        case "$remote_url" in
            https://github.com/*)
                local repo="${remote_url#https://github.com/}"
                repo="${repo%.git}"
                remote_url="git@github.com:${repo}.git"
                ;;
            https://codeberg.org/*)
                local repo="${remote_url#https://codeberg.org/}"
                repo="${repo%.git}"
                remote_url="git@codeberg.org:${repo}.git"
                ;;
        esac
        printf "temux: cloning %s into ~/projects/%s on forge-shell...\n" "$remote_url" "$project"
        if ! ssh_vps "temux-host init $(printf '%q' "$remote_url")"; then
            die "run: auto-init failed. Try manually:
         ssh -i ~/.ssh/neith-forge vincent@forge-shell.neithforge.dev \\
             temux-host init $remote_url"
        fi
    else
        printf "temux: pulling on forge-shell...\n"
        ssh_vps "cd ~/projects/$project && git pull --ff-only"
    fi

    # place marker + install hooks locally
    place_marker "$project"
    install_hooks

    # build remote temux-host invocation
    local -a remote_args=("run" "$project")
    [[ $no_notify -eq 1 ]] && remote_args+=("--no-notify")
    if [[ ${#passthrough[@]} -gt 0 ]]; then
        remote_args+=("--")
        remote_args+=("${passthrough[@]}")
    fi

    # quote each arg for the remote shell
    local remote_cmd
    remote_cmd="temux-host $(printf '%q ' "${remote_args[@]}")"

    printf "temux: starting session on forge-shell...\n"
    ssh_vps "$remote_cmd"

    printf "\ntemux: ✓ done\n"
    printf "  attach: temux attach %s\n" "$project"
    printf "  reclaim workstation: git pull (clears the marker)\n"
}

cmd_attach() {
    local project="${1:-}"
    [[ -n "$project" ]] || project=$(infer_project) \
        || die "attach: cannot infer project; pass it explicitly"
    exec ssh -i "$SSH_KEY" -o StrictHostKeyChecking=accept-new -t "$SSH_HOST" \
        "tmux attach-session -t $(printf '%q' "$project")"
}

main() {
    local subcommand="${1:-}"
    case "$subcommand" in
        run)            shift; cmd_run "$@" ;;
        attach)         shift; cmd_attach "$@" ;;
        -h|--help|help) usage ;;
        "")             usage; exit 1 ;;
        *)              die "unknown subcommand '$subcommand'. See: temux --help" ;;
    esac
}

main "$@"
