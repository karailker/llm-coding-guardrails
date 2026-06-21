# Guardrails in Action: Before & After Examples

These examples illustrate how the guidelines in [AGENTS.md](../AGENTS.md) protect your codebase from common LLM behaviors. By showing the contrast between a "Naive AI Response" and a "Guardrail-Enforced Response," you can see exactly why defensive prompting is a senior-level necessity.

## Available Examples

1. **[Surgical Changes](surgical_changes.md)** — Preventing the AI from refactoring adjacent, unrelated code and polluting Git diffs.
2. **[No Optimization Without Proof](no_optimization_without_proof.md)** — Stopping the AI from writing over-engineered memoization or custom algorithms on assumption without profiling data.

---

## How to Test on Your Team

To see the difference in your own project:
1. Try asking an AI assistant to make a small change *without* these guardrails active. Notice how much adjacent code it "beautifies" or alters.
2. Place `AGENTS.md` and appropriate pointer files in your root.
3. Ask for the same change. Observe the disciplined, clean, and minimal changes that result.
