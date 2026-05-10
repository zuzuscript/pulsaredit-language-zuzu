# language-zuzu

Syntax highlighting package for ZuzuScript in Atom and PulsarEdit.

## Features

- Highlights ZuzuScript code in `.zzs` and `.zzm` files.
- Recognizes current keywords, operators, literals, comments, and regexps.
- Supports embedded Pod blocks (`=pod` ... `=cut`) as documentation.
- Highlights template string interpolation in backtick strings, including
  triple-backtick templates.
- Provides folding markers for class, trait, function, and method blocks.

## Install (development)

In Atom:

```bash
apm link --dev /path/to/zuzu/extras/pulsaredit/language-zuzu
```

In Pulsar:

```bash
ppm link --dev /path/to/zuzu/extras/pulsaredit/language-zuzu
```

Then open a `.zzs` or `.zzm` file.
