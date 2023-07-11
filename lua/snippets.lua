local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet

ls.add_snippets("lua", {
	s(
		{ trig = "snip", name = "luasnip snippet" },
		c(1, {
			fmt(
				[=[
				s(
					{{ trig = "{}", name = "{}" }},
					fmt(
						[[
							{}
						]],
						{{
							{}
						}}
					)
				),
			]=],
				{
					i(1),
					i(2),
					i(3),
					i(4),
				}
			),
			fmt(
				[=[s({{ trig = "{}", name = "{}" }}, fmt({}, {{ {} }})),]=],
				{ i(1), i(2), c(3, { { t('"'), i(1), t('"') }, { t("[["), i(1), t("]]") } }), i(4) }
			),
			fmt(
				[[
					s({{ trig = "{}", name = "{}" }}, {{
						{}
					}}),
				]],
				{
					i(1),
					i(2),
					i(3),
				}
			),
		})
	),
	s({ trig = "funs", name = "one-liner function" }, fmt("function() {} end", { i(1) })),
})

ls.add_snippets("javascript", {
	s({ trig = "clog", name = "console.log()" }, fmt("console.log({})", { i(1) })),
})

ls.add_snippets("go", {
	s(
		{ trig = "funct", name = "test function" },
		fmt(
			[[
				func Test{}(t *testing.T) {{
					{}
				}}
			]],
			{
				i(1),
				i(0),
			}
		)
	),
	s(
		{ trig = "funcm", name = "method func" },
		fmt(
			[[
				func ({}) {}({}) {}{{
					{}
				}}
			]],
			{
				i(1),
				i(2),
				i(3),
				i(4),
				i(0),
			}
		)
	),
	s(
		{ trig = "main", name = "main()" },
		fmt(
			[[
				func main() {{
					{}
				}}
			]],
			{
				i(0),
			}
		)
	),
	s({ trig = "pmain", name = "package main" }, {
		t("package main"),
	}),
	s(
		{ trig = "iferr", name = "if err != nil" },
		fmt(
			[[
				if err != nil {{
					{}
				}}
			]],
			{
				i(0),
			}
		)
	),
	s(
		{ trig = "handler", name = "http.Handler" },
		fmt(
			[[
				func {}(w http.ResponseWriter, r *http.Request) {{
					{}
				}}
			]],
			{
				i(1),
				i(0),
			}
		)
	),
})

ls.add_snippets("markdown", {
	s({ trig = "img", name = "image" }, fmt("![{}]({})", { i(1), i(2) })),
})

ls.add_snippets("sh", {
	s({ trig = "com", name = "$(...)" }, fmt("$({})", { i(1) })),
})

ls.add_snippets("cmake", {
	postfix({ trig = ".dbg", name = "log variable" }, {
		l('message(NOTICE "' .. l.POSTFIX_MATCH .. " = $" .. l.POSTFIX_MATCH .. '")'),
	}),
})

ls.add_snippets("python", {
	s(
		{ trig = "def", name = "function" },
		fmt(
			[[
				def {}({}):
					{}
			]],
			{
				i(1),
				i(2),
				i(0, "pass"),
			}
		)
	),
	s({ trig = "print", name = "print()" }, fmt("print({})", { i(1) })),
	s(
		{ trig = "class", name = "class" },
		fmt(
			[[
				class {}({}):
					{}
			]],
			{
				i(1),
				i(2),
				i(0, "pass"),
			}
		)
	),
	s(
		{ trig = "if", name = "if-else" },
		c(1, {
			fmt("if {}:\n\t{}", { i(1), i(0) }),
			fmt("if {}:\n\t{}\nelse\n\t{}", { i(1), i(2), i(3) }),
		})
	),
})
