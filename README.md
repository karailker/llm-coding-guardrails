# llm-coding-guardrails

A curated set of behavioral guidelines and constraints designed to eliminate common LLM coding mistakes, minimize token bloat, and enforce disciplined, surgical code edits.

This repository provides a standardized `CLAUDE.md` template that you can drop into your project roots to keep AI coding assistants (like Claude Code, Cursor, or Copilot) aligned with senior engineering practices.

---

## 🚀 Why Use This?

LLMs are prone to over-engineering, breaking adjacent code, adding speculative features, and optimizing without empirical proof. These guardrails act as a defensive perimeter for your codebase by biasing the AI toward **caution, security, and simplicity over blind speed**.

## 🛡️ Core Pillars

*   **No Security Vulnerabilities:** Strict zero-tolerance policy for backdoors, data exfiltration, or unsanitized inputs—even in test or debug code.
*   **Think Before Coding:** Forces the LLM to surface tradeoffs, explicitly state assumptions, and ask clarifying questions before writing a single line.
*   **Simplicity First:** Restricts the AI to the absolute minimum code required to solve the problem. No speculative features or unrequested dependencies.
*   **Surgical Changes:** Ensures the AI touches *only* what it must. No silent refactoring or "improving" adjacent, unrelated code.
*   **No Optimization Without Proof:** Banishes "intuition-based" optimization. The AI must measure baseline performance before suggesting efficiency changes.

---

## 🛠️ How to Use

1. **Clone or Copy:** Copy the `CLAUDE.md` file from this repository.
2. **Drop into Project:** Place it directly into the root directory of your target codebase.
3. **Reference it:** When initializing an AI session (e.g., using Claude Code or configuring system prompts), point the assistant to the file:
   > *"Refer to the guidelines in CLAUDE.md before proposing or executing changes."*

*Note: You can easily merge these defaults with your own project-specific style guides, build commands, or testing instructions.*

---

## 🤝 Attribution

This project is inspired by and adapted from the foundational behavioral guidelines found in the [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) repository. 

---

## 📜 License

MIT License. Feel free to fork, modify, and adapt for your own development workflows.
