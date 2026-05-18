describe "ZuzuScript grammar", ->
	grammar = null

	beforeEach ->
		grammar ?= atom.grammars.loadGrammarSync("#{__dirname}/../grammars/zuzu.cson")

	tokenScopes = (line, value) ->
		for token in grammar.tokenizeLine(line).tokens
			return token.scopes if token.value is value
		[]

	tokenScopesContaining = (line, value) ->
		for token in grammar.tokenizeLine(line).tokens
			return token.scopes if token.value.indexOf(value) isnt -1
		[]

	expectScopesToContain = (line, value, scope) ->
		expect(tokenScopes(line, value)).toContain(scope)

	expectContainingScopesToContain = (line, value, scope) ->
		expect(tokenScopesContaining(line, value)).toContain(scope)

	expectScopesNotToContain = (line, value, scope) ->
		expect(tokenScopes(line, value)).not.toContain(scope)

	it "parses the grammar", ->
		expect(grammar).toBeTruthy()
		expect(grammar.scopeName).toBe("source.zuzu")

	it "highlights current keywords and contextual declaration words", ->
		line = "async function f() { spawn { await { do {} } } }"
		expectScopesToContain(line, "async", "storage.type.function.zuzu")
		expectScopesToContain(line, "spawn", "keyword.control.flow.zuzu")
		expectScopesToContain(line, "await", "keyword.control.flow.zuzu")

		line = "let field with get, set, clear, has but weak;"
		expectScopesToContain(line, "weak", "storage.modifier.zuzu")
		expectScopesToContain(line, "get", "storage.modifier.accessor.zuzu")
		expectScopesToContain(line, "set", "storage.modifier.accessor.zuzu")
		expectScopesToContain(line, "clear", "storage.modifier.accessor.zuzu")
		expectScopesToContain(line, "has", "storage.modifier.accessor.zuzu")

	it "does not highlight stale keywords", ->
		line = "elsif given isa my sub use contains difference"
		for word in line.split(/\s+/)
			expectScopesNotToContain(line, word, "keyword.control.flow.zuzu")
			expectScopesNotToContain(line, word, "storage.modifier.zuzu")
			expectScopesNotToContain(line, word, "storage.type.function.zuzu")
			expectScopesNotToContain(line, word, "keyword.operator.word.zuzu")

	it "highlights current operators and delimiters", ->
		line = "x := y ~= /a/i -> z; x @? p; x **= 2; obj.(name)(1)"
		expectScopesToContain(line, ":=", "keyword.operator.assignment.zuzu")
		expectScopesToContain(line, "~=", "keyword.operator.assignment.zuzu")
		expectScopesToContain(line, "/a/i", "string.regexp.zuzu")
		expectScopesToContain(line, "->", "keyword.operator.lambda.zuzu")
		expectScopesToContain(line, "@?", "keyword.operator.arithmetic.zuzu")
		expectScopesToContain(line, "**=", "keyword.operator.assignment.zuzu")
		expectScopesToContain(line, ".(", "punctuation.separator.zuzu")

		line = "a & b | c ^ d; !ok; √ 9; ⌊ 1.2 ⌋; <<< 1 >>>"
		expectScopesToContain(line, "&", "keyword.operator.bitwise.zuzu")
		expectScopesToContain(line, "|", "keyword.operator.bitwise.zuzu")
		expectScopesToContain(line, "^", "keyword.operator.bitwise.zuzu")
		expectScopesToContain(line, "!", "keyword.operator.logical.zuzu")
		expectScopesToContain(line, "√", "keyword.operator.arithmetic.zuzu")
		expectContainingScopesToContain(line, "⌊", "punctuation.section.braces.begin.zuzu")
		expectContainingScopesToContain(line, "⌋", "punctuation.section.braces.end.zuzu")
		expectScopesToContain(line, "<<<", "punctuation.section.braces.begin.zuzu")
		expectScopesToContain(line, ">>>", "punctuation.section.braces.end.zuzu")

		line = "let merged := opts default { host: \"localhost\" }; call(... merged)"
		expectScopesToContain(line, "default", "keyword.operator.word.zuzu")
		expectScopesToContain(line, "...", "punctuation.separator.zuzu")

		line = "switch (mode: eq) { default: return null; }"
		expectScopesToContain(line, "default", "keyword.control.flow.zuzu")

	it "highlights current literals", ->
		line = "let ok := ⊤; let no := ⊥; let empty := ∅;"
		expectScopesToContain(line, "⊤", "constant.language.boolean.zuzu")
		expectScopesToContain(line, "⊥", "constant.language.boolean.zuzu")
		expectScopesToContain(line, "∅", "constant.other.empty-set.zuzu")

		expectScopesToContain("let b := 'abc';", "abc", "string.quoted.single.zuzu")
		expectScopesToContain("let b := '''abc''';", "'''", "string.quoted.single.block.zuzu")
		expectScopesToContain("let t := ```abc```;", "```", "string.template.backtick.block.zuzu")
