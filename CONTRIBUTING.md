# Contributing to LLM Coding Guardrails

First off, thank you for considering contributing to LLM Coding Guardrails! It's because of people like you that this toolkit remains effective and up-to-date as AI assistants and their behavioral patterns change.

## 🌟 Our Philosophy

These guardrails bias toward **caution over speed**, and represent a defensive strategy against common LLM mistakes (over-engineering, security shortcuts, unrequested refactoring, premature optimization).

When proposing or editing guidelines, please keep our core tenets in mind:
1. **Tool & Language Agnostic:** The rules should be general enough to apply to any project (Python, TypeScript, Rust, Go, etc.) and any tool (Cursor, Claude Code, Copilot, Windsurf, Aider, etc.).
2. **Minimal & Direct:** We avoid fluff or highly specific edge-cases. Every rule must have a high signal-to-noise ratio.
3. **Canonical Truth:** `AGENTS.md` (and `CLAUDE.md` where appropriate) is the single source of truth. Pointer files should remain small relative references.

---

## 🛠️ How to Contribute

### 1. Propose Changes or Additions
The landscape of LLM capabilities and quirks changes rapidly. If you observe a common AI failure mode that could be prevented with a general guideline:
- **Open an Issue:** Discuss the proposed rule and share examples of what the AI does with/without the rule.
- **Explain the Tradeoff:** Briefly explain why this rule is needed and what the tradeoff is.

### 2. Submit a Pull Request
If there's an agreed-upon fix or rule upgrade:
1. **Fork the repo** and create a feature branch.
2. Update `AGENTS.md` (and other files if they are meant to duplicate details like `CLAUDE.md`).
3. Ensure syntax remains clear, consistent in tone, and direct.
4. Keep the list of files and tools in `README.md` updated if you are adding integration with a new AI agent.
5. Create a Pull Request with a clear description of the modifications and the rationale behind them.

---

## 📝 Tone & Style Guide
- **Empirical over Intuitive:** Guidelines must be objective (e.g., "Do not optimize without profile baseline/measurement" instead of "Make things fast").
- **Clarity over Politeness:** The instructions written for AIs must be unambiguous, descriptive, and absolute where required. Use bolding to emphasize non-negotiable behaviors, and tabular structures where helpful (like the Security boundaries table).

Thank you for helping developers write cleaner, more secure code alongside AI!
