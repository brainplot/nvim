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
local ms = ls.multi_snippet
-- local k = require("luasnip.nodes.key_indexer").new_key

ls.add_snippets("lua", {
	s({ trig = "snip", name = "luasnip snippet" }, {
		t('s({ trig = "'),
		i(1),
		t('", name = "'),
		i(2),
		t({ '" }, {', "\t" }),
		i(0),
		t({ "", "})," }),
	}),
})

ls.add_snippets("javascript", {
	s({ trig = "clog", name = "console.log()" }, {
		t("console.log("),
		i(1),
		t(")"),
	}),
})

ls.add_snippets("go", {
	s({ trig = "funct", name = "test func" }, {
		t("func Test"),
		i(1),
		t({ "(t *testing.T) {", "\t" }),
		i(0),
		t({ "", "}" }),
	}),
	s({ trig = "funcm", name = "method func" }, {
		t("func ("),
		i(1),
		t(") "),
		i(2),
		t("("),
		i(3),
		t(") "),
		i(4, "string "),
		t({ "{", "\t" }),
		i(0),
		t({ "", "}" }),
	}),
	s({ trig = "main", name = "main()" }, {
		t({ "func main() {", "\t" }),
		i(0),
		t({ "", "}" }),
	}),
	s({ trig = "pmain", name = "package main" }, {
		t("package main"),
	}),
	s({ trig = "iferr", name = "if err != nil" }, {
		t({ "if err != nil {", "\t" }),
		i(0),
		t({ "", "}" }),
	}),
	s({ trig = "handler", name = "http.Handler" }, {
		t("func "),
		i(1),
		t({ "(w http.ResponseWriter, r *http.Request) {", "\t" }),
		i(0),
		t({ "", "}" }),
	}),
})

ls.add_snippets("markdown", {
	s({ trig = "img", name = "image" }, {
		t("!["),
		i(1),
		t("]("),
		i(2),
		t(")"),
	}),
})
