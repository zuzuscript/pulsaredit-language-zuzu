# AGENTS.md

## Repository Scope

This repository contains the Atom/Pulsar ZuzuScript language package in
`language-zuzu/`.

Keep future work self-contained. Do not use sibling directories as language
references. The local submodules provide the source material:

- `docs/userguide/zuzuscript-guide/AA-bnf.md`
- `docs/userguide/zuzuscript-guide/AB-operator-precedence.md`
- `docs/userguide/operators-table.html`
- `docs/examples/*.zzs`

If those paths are missing, initialize the submodules before making syntax
decisions.

## Keeping Syntax Current

Update `language-zuzu/grammars/zuzu.cson` from the local BNF and operator
appendix. Check:

- current reserved words and contextual words;
- stale words that should no longer receive keyword/operator scopes;
- word-like and symbolic operators, including Unicode aliases;
- assignment, path, lambda, dynamic member-call, collection, floor/ceil,
  and bag/set delimiters;
- string, binary-string, template, regexp, number, boolean, null, and
  empty-set literals;
- embedded POD and comments.

Update `language-zuzu/settings/language-zuzu.cson` when syntax changes
affect indentation, word boundaries, or folding. Folding markers should
cover class, trait, function, and method blocks.

Keep `language-zuzu/spec/` tests aligned with grammar changes. Add focused
cases for new tokens and for stale words that must remain ordinary
identifiers.

## Validation

Run the package tests from inside `language-zuzu/`:

```bash
pulsar --package test
```

If Pulsar is unavailable, at least inspect the CSON grammar for syntax
errors with an available CSON parser and run equivalent static regex checks
for current keywords, stale keyword removal, current operators, literals,
and folding markers.

Keep validation examples drawn from the local userguide and
`docs/examples`.
