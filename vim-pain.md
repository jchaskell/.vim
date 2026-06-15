# Vim Pain Points

A running log of things in vim that annoy, slow you down, or make you reach for
VS Code. The goal is to turn vague friction into concrete config/plugin changes.

## How this workflow works

- Press **`,n`** (`<leader>n`) anytime inside vim. It opens this file in a split,
  appends a new timestamped bullet, and drops you into insert mode at the bottom
  so you can type the annoyance in one motion. Save with `:w` and `,n` again or
  `<C-w>q` to get back to your work.
- Capture the friction *in the moment* — don't worry about polish. A half-sentence
  like "indenting pasted JSON is a pain" is enough.
- Periodically, hand this list to Claude Code (e.g. "here's my vim-pain.md, what
  can we fix?"). Each line usually maps to a setting, a mapping, or a plugin.

## What to write down

- A keystroke sequence that felt clumsy or repetitive
- Something VS Code did automatically that vim doesn't (or vice-versa)
- A filetype that indents/highlights wrong
- "I wish I could quickly ___" (jump to definition, rename, format, etc.)
- Any error message or weird behavior on startup

## Pain points

<!-- ,n appends below this line -->
