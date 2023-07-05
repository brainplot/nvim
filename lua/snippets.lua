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

ls.snippets = {
	go = {
		s("struct", {
			t("type "),
			i(1),
			t({ " struct {", "\t" }),
			i(0),
			t({ "", "}" }),
		}),
		s("func", {
			t("func "),
			i(1),
			t("("),
			i(2),
			t(")"),
			i(3),
			t({ " {", "\t" }),
			i(0),
			t({ "", "}" }),
		}),
		s("funcm", {
			t("func ("),
			i(1),
			t(") "),
			i(2),
			t("("),
			i(3),
			t(")"),
			i(4),
			t({ " {", "\t" }),
			i(0),
			t({ "", "}" }),
		}),
		s("switch", {
			t("switch "),
			i(1),
			t({ " {", "" }),
			i(0),
			t({ "", "}" }),
		}),
		s("handler", {
			t("func "),
			i(1),
			t({ "(w http.ResponseWriter, r *http.Request) {", "\t" }),
			i(0),
			t({ "", "}" }),
		}),
		s("pmain", {
			t("package main"),
		}),
		s("fmain", {
			t({ "func main() {", "\t" }),
			i(0),
			t({ "", "}" }),
		}),
		s("ftest", {
			t("func Test"),
			i(1),
			t({ "(t *testing.T) {", "\t" }),
			i(0),
			t({ "", "}" }),
		}),
		s("iferr", {
			t({ "if err != nil {", "\t" }),
			i(0),
			t({ "", "}" }),
		}),
	},
}
