# Vim Setup & Cheatsheet

Personal reference for this vim config (`~/.vim/vimrc`). Open it anytime with
**`,?`** (opens in a new tab). Jot annoyances with **`,n`** → see `~/.vim/vim-pain.md`.

> **Leader key is `,` (comma).** Everywhere below, `,x` means press comma then x.
> Plugins are managed by **vim-plug**: `:PlugInstall` / `:PlugUpdate` / `:PlugClean`.

---

## Custom shortcuts (defined in vimrc)

### Editing / meta
| Key | Does |
|-----|------|
| `jj` (insert mode) | Escape to normal mode |
| `,ev` | Edit vimrc in a vertical split |
| `,sv` | Source (reload) vimrc |
| `,?` | Open this cheatsheet in a new tab |
| `,n` | Jot a vim pain point (`~/.vim/vim-pain.md`) |
| `,c` | Ask Claude Code a question (prefills `:Ask `) |
| `,H` | Fuzzy-search all vim help tags (fzf) |
| `,M` | Fuzzy-search your own mappings (fzf) |
| `:w!!` | Save current file with sudo (when you opened it read-only) |

### Files / buffers / search
| Key | Does | Plugin |
|-----|------|--------|
| `,f` | Fuzzy-find files | fzf |
| `,b` | Fuzzy-switch buffers | fzf |
| `,a` | Ripgrep from vim's current dir, recursively† | fzf |
| `,A` | Same, seeded with the word under the cursor | fzf |
| `,,` | Re-open the previous (alternate) file | builtin |
| `,<space>` | Clear search highlight | builtin |
| `Ctrl-p` | CtrlP fuzzy file finder (alternative to `,f`) | ctrlp |

† **What "the project" means here:** `,a`/`,A` run ripgrep starting from vim's
current working directory (`:pwd`) and recurse into every subfolder. It is *not*
tied to a git repo — but ripgrep skips anything in `.gitignore`/`.ignore` and
hidden files by default. So to search a whole repo, launch vim from the repo root
(or `:cd` there). Note `Ctrl-p` (CtrlP) differs: it auto-roots to the nearest
enclosing git/VCS repo regardless of cwd.

### Git
| Key | Does | Plugin |
|-----|------|--------|
| `,gs` | `:Git` status window | fugitive |
| `,gb` | `:Git blame` | fugitive |
| `,gd` | `:Gdiffsplit` (diff vs index) | fugitive |
| `]c` / `[c` | Jump to next / previous changed hunk | gitgutter |
| `,hs` / `,hu` / `,hp` | Stage / undo / preview a hunk | gitgutter |

### Run / send code
| Key | Does |
|-----|------|
| `,p` | Pipe the whole buffer through `python` |
| `,r` | Pipe the whole buffer through `R` |
| `Ctrl-c Ctrl-c` | Send paragraph/selection to a REPL (vim-slime) |
| `,s` | Save a session (`:mksession`); reopen later with `vim -S` |

### Custom command
- `:DiffOrig` — diff the current buffer against the file on disk (see unsaved changes).

---

## Answering your own vim questions

Two tiers, depending on whether you know the term:

1. **Know roughly what it's called → built-in help (instant, offline):**
   - `:help {topic}` — e.g. `:help tabpage`, `:help gt`, `:help :Gdiffsplit`
   - `,M` (`:Maps`) — fuzzy-search *your own* mappings ("what did I bind for…?")
   - `,H` (`:Helptags`) — fuzzy-search *all* help tags when you don't know the exact name
2. **Don't know the term / want it explained → ask Claude:**
   - `,c` then type a question, e.g. `,c how do I move between tabs<CR>`
   - Or `:Ask how do I delete to end of line`. The answer streams into a terminal
     split (non-blocking); close it with `:q` or `Ctrl-w q`.

**Tabs (the thing you'll forget first):** `gt` next tab, `gT` previous, `{N}gt` jump
to tab N (`2gt`). Open with `:tabedit`/`:tabnew`, close with `:tabclose`.

## Plugins & how to use them

### fzf + fzf.vim — fuzzy finder
Beyond `,f` / `,b` / `,a`, useful commands you can type directly:
- `:Files` `:GFiles` (git-tracked) `:Buffers` `:History`
- `:Rg <pattern>` — live grep from vim's cwd (see † above) `:BLines` — fuzzy within the current file
- `:Commits` `:BCommits` — fuzzy git log; `:Maps` — search your own mappings; `:Helptags`
- Inside the picker: `Enter` open, `Ctrl-t` new tab, `Ctrl-x` split, `Ctrl-v` vsplit, `Tab` multi-select.

### vim-fugitive — Git inside vim
- `,gs` opens the status window. In it: `s` stage, `u` unstage, `=` toggle inline diff,
  `cc` commit, `X` discard, `Enter` open file.
- `:Git <anything>` runs any git command. `:Gread` reverts buffer to index, `:Gwrite` stages it.

### vim-gitgutter — change signs in the gutter
- Shows `+ ~ -` for added/changed/removed lines vs git.
- `]c` / `[c` jump hunks; `,hp` preview, `,hs` stage, `,hu` undo a hunk.

### vim-visual-multi — multiple cursors
- `Ctrl-n` — select word under cursor; press again to add the next occurrence.
- Then: `n` next match, `N` previous, `q` skip this one, `[` / `]` move between cursors.
- `\\A` — select **all** occurrences at once. (VM's own leader is `\`.)
- Type/edit normally and all cursors mirror it. `Esc` to exit.

### vim-surround — work with surrounding pairs
- `cs"'` change surrounding `"` → `'` `ds(` delete surrounding `()`
- `ysiw)` surround a word with `()` `yss"` surround the whole line
- Visual mode: select, then `S<tag>` to wrap (e.g. `S<p>`).

### NERDTree — file explorer
- No key is bound by default — run `:NERDTreeToggle` (or `:NERDTree`).
- Inside: `o` open, `t` open in tab, `s` vsplit, `I` toggle hidden, `m` filesystem menu, `?` help.
- Hidden files are shown; `.git`, `.DS_Store`, `*.vim`, `*~` are ignored.
- *(Tip: bind it with `nnoremap <leader>t :NERDTreeToggle<CR>` if you want a shortcut.)*

### vim-slime — send code to a REPL
- Target is a vim `:terminal` buffer (`g:slime_target = "vimterminal"`). Open one with
  `:terminal python` (or `R`), then `Ctrl-c Ctrl-c` sends the current paragraph to it.
- First send asks which terminal to use. `Ctrl-c v` reconfigures the target.
- Inside tmux instead? Set `let g:slime_target = "tmux"` in the vimrc.

### vim-pydocstring — Python docstring stubs
- `:Pydocstring` generates a docstring for the function under the cursor.
- Requires the `doq` CLI: `pip install doq`.

### delimitMate — auto-close pairs
- Typing `(`, `[`, `"`, etc. inserts the closing match. `Enter` and `Space` expand
  sensibly inside brackets.

### indentLine — indent guides
- Thin vertical lines marking indent levels (handy for Python/YAML).

### vim-airline (+ themes) — statusline
- The status/tab line at the bottom (theme: `badwolf`). Buffers also show along the top
  via **vim-buftabline** — switch with `:bn` / `:bp`, or `,b` (fzf).

### vim-markdown — markdown editing
- Folding disabled, conceal off, frontmatter highlighted (YAML/TOML/JSON).
- `:Toc` opens a clickable table of contents. `ge` follows `file#anchor` links.

---

## Built-in behaviors worth remembering (from your settings)

- **System clipboard**: yanks/pastes use the macOS clipboard (`clipboard=unnamed`).
  So `yy` then Cmd-V works in other apps, and Cmd-C then `p` works here.
- **Persistent undo**: undo history survives closing the file (`undodir=~/.vim/undodir`).
  `u` undo, `Ctrl-r` redo — across sessions.
- **Search**: incremental + highlighted; case-insensitive unless you type a capital
  (`ignorecase` + `smartcase`). `,<space>` clears the highlight.
- **Buffers, not tabs, by default**: `hidden` is on, so you can switch away from a
  modified buffer. `:bn`/`:bp`/`:b name` to move; buftabline shows them up top.
- **Splits** open below/right (`splitbelow`/`splitright`). Move with `Ctrl-w h/j/k/l`,
  resize with `Ctrl-w +/-/</>`.
- **80-col guide**: `colorcolumn=80` draws a vertical line.
- **Spell check** is on for markdown and git commit messages: `]s`/`[s` next/prev
  misspelling, `z=` suggestions, `zg` add word to dictionary.
- **Mouse** is enabled (`mouse=a`) — click, select, resize splits.

## Indentation by filetype (auto-applied)
- **Python** — 4 spaces, textwidth 80   **R** — 2 spaces, textwidth 80
- **YAML / C++ / JSON** — 2 spaces, expandtab
- **Go / Lua / nginx / vim** — real tabs, width 4
- **Dockerfile / fstab / systemd / gitconfig / sh / toml** — real tabs

---

## Maintaining this setup
- Edit config: `,ev`, then reload with `,sv` (or restart vim).
- Add a plugin: put a `Plug '...'` line in the vim-plug block, save, run `:PlugInstall`.
- Remove a plugin: delete its `Plug` line, run `:PlugClean`.
- Update everything: `:PlugUpdate`.
- This file lives at `~/.vim/vim-setup.md`; the pain-points log at `~/.vim/vim-pain.md`.

## How this repo is structured (git)
- This config is a git repo at `~/.vim`. Tracked: `vimrc`, `autoload/plug.vim`
  (the vim-plug bootstrap), `colors/`, and these docs.
- **Plugins are NOT tracked.** They're declared by the `Plug` lines in `vimrc`
  and installed into `plugged/`, which is gitignored — vim-plug reproduces them.
- Also gitignored: `undodir/` (undo files), `*.swp`, and `*.bak` backups.
- **Fresh clone:** just `git clone` to `~/.vim` and launch `vim`. It auto-fetches
  vim-plug if missing and runs `:PlugInstall` on first start, then reloads — no
  manual setup. (`fzf` still needs to be on the system, e.g. `brew install fzf`.)
