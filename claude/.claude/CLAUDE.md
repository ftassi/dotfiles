Il mio linguaggio principale è Rust. Quando lavoro con altri linguaggi,
aiutami a mappare i concetti Rust agli equivalenti idiomatici del linguaggio
in uso. Se faccio riferimento a pattern Rust (Result, Option, match, traits,
lifetimes), traduci nel modo più appropriato per il contesto.

## Commit Messages

All commit messages must be in English.

### Format
```
<summary>

<description (optional)>
```

### Summary (first line)
- Max 72 characters
- Imperative mood: "Add feature" not "Added feature" or "Adds feature"
- Capitalize first letter, no period at the end
- Describes what happens when the commit is applied

### Description (body)
- Max 72 characters per line
- Separated from summary by a blank line
- Explains the "why", not the "what" (the diff shows the what)

**Include description when:**
- Structural refactoring
- Workaround for external bug/limitation
- Part of a larger effort
- Spike or temporary implementation
- Non-obvious trade-offs or constraints

**Skip description for:**
- Trivial fixes (typos, formatting)
- Self-explanatory changes

### Content of "why"
- Context/problem that motivated the change
- If part of a larger work
- If it's a spike to be refined later
- Trade-offs considered
- External constraints not obvious from the diff

### Behavior
- If the "why" is unclear from the conversation, ask before committing
- Propose a draft message for approval
- NEVER include Claude as co-author or any trace of AI assistance

## Code Philosophy

Code is a liability, not an asset. Every line has cognitive and maintenance cost.

### Write only what's needed
- Implement features when they're needed, not when they "might be useful"
- If a function isn't called, don't write it
- If a field isn't read, don't add it
- `pub` only what's actually used from outside the module

### Extractions and refactoring
- Extraction = moving existing code, not adding new code
- Don't add "helper" functions during refactoring that didn't exist before

### Test code
- Test utilities are acceptable to make tests more expressive or reduce boilerplate
- Keep them minimal and clearly scoped to tests (e.g., `#[cfg(test)]`, `test/` directory, private to test module)
- Don't add production code (`pub`) just to make testing easier

### Before writing code, ask:
- Who calls this?
- If the answer is "no one yet" → don't write it

### Abstractions
- Prefer patterns that can evolve over premature abstractions
- Duplication is cheaper than the wrong abstraction
- Extract when you see the pattern, not when you imagine it
