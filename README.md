# llm-coding-guardrails

A curated set of behavioral guidelines and constraints designed to eliminate common LLM coding mistakes, minimize token bloat, and enforce disciplined, surgical code edits.

This repository provides a standardized set of guideline files - centered on a single `AGENTS.md` - that you can drop into your project root to keep AI coding assistants (Claude Code, Cursor, Antigravity, OpenCode, Copilot, and more) aligned with senior engineering practices.

---

## 🚀 Why Use This?

LLMs are prone to over-engineering, breaking adjacent code, adding speculative features, and optimizing without empirical proof. These guardrails act as a defensive perimeter for your codebase by biasing the AI toward **caution, security, and simplicity over blind speed**.

## 🛡️ Core Pillars

*   **No Security Vulnerabilities:** Strict zero-tolerance policy for backdoors, data exfiltration, or unsanitized inputs—even in test or debug code.
*   **Think Before Coding:** Forces the LLM to surface tradeoffs, explicitly state assumptions, and ask clarifying questions before writing a single line.
*   **Simplicity First:** Restricts the AI to the absolute minimum code required to solve the problem. No speculative features or unrequested dependencies.
*   **Surgical Changes:** Ensures the AI touches *only* what it must. No silent refactoring or "improving" adjacent, unrelated code.
*   **No Optimization Without Proof:** Banishes "intuition-based" optimization. The AI must measure baseline performance before suggesting efficiency changes.
*   **Testing Standards:** Tests are written only when asked for - but when they are, they follow AAA structure, behavior-based naming, and the test pyramid, with mocks reserved for genuinely slow or non-deterministic dependencies.
*   **State & Side-Effect Discipline:** New code avoids hidden mutation and surprising side effects—a function's name is its contract, and concurrent code never assumes execution order.
*   **Goal-Driven Execution:** Every task gets a verifiable success criterion and, for larger tasks, a stated plan, so the AI can loop independently instead of requiring constant check-ins.

## 📁 What's in This Repo

`AGENTS.md` is the single source of truth. Every other file is a one-paragraph pointer, so each tool finds the guidelines through its own native convention without duplicating ~150 lines of content five times over.

| File | Read by |
|---|---|
| `AGENTS.md` | Cursor, Antigravity, OpenCode, Codex, Windsurf, Aider, and most other agents - **the canonical file, edit this one** |
| `CLAUDE.md` | Claude Code |
| `.github/copilot-instructions.md` | GitHub Copilot |
| `.cursorrules` | Older Cursor versions (fallback) |
| `.antigravity/rules.md` | Older/alternate Antigravity setups (fallback) |

---

## 🛠️ How to Use

1.  **Copy the files:** Copy `AGENTS.md` plus whichever pointer files match the tools you use - preserving the `.github/` and `.antigravity/` folder structure - into your project root.
2.  **Most tools just work:** Cursor, Antigravity, OpenCode, Codex, Windsurf, and others read `AGENTS.md` automatically. Claude Code and Copilot pick up their pointer files automatically too.
3.  **Fallback / manual reference:** for any setup that doesn't auto-discover these files, point the assistant at `AGENTS.md` directly:
    > *"Refer to the guidelines in AGENTS.md before proposing or executing changes."*

*Note: You can easily merge these defaults with your own project-specific style guides, build commands, or testing instructions - either directly inside `AGENTS.md`, or in a separate file that `AGENTS.md` references.*

---

## 🤝 Attribution

This project is inspired by and adapted from the foundational behavioral guidelines found in the [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) repository.

---

## 📜 License

MIT License. Feel free to fork, modify, and adapt for your own development workflows.
