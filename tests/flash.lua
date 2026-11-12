local repo_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
local pattern
package.loaded.flash = {
	jump = function(opts)
		pattern = opts.pattern
	end,
}
local spec = dofile(repo_dir .. "/.config/nvim/lua/plugins/flash.lua")
for _, key in ipairs(spec.keys) do
	if key[1] == "<leader>sf" then
		key[2]()
	end
end
assert(pattern, "Could not obtain the Flash hint pattern")

local function assert_match(input, expected)
	local actual = vim.fn.matchstr(input, pattern)
	assert(actual == expected, ("Input %q: expected %q, got %q"):format(input, expected, actual))
end

local cases = {
	{ "https://example.com/a?x=1&y=2", "https://example.com/a?x=1&y=2" },
	{ "http://example.com", "http://example.com" },
	{ "(https://example.com/a).", "https://example.com/a" },
	{ "https://example.com/a.", "https://example.com/a." },
	{ "550e8400-e29b-41d4-a716-446655440000", "550e8400-e29b-41d4-a716-446655440000" },
	{ "0.0.0.0", "0.0.0.0" },
	{ "192.168.1.1", "192.168.1.1" },
	{ "255.255.255.255", "255.255.255.255" },
	{ "256.1.2.3", "" },
	{ "1.2.3.999", "" },
	{ "deadbee", "deadbee" },
	{ "deadbeef", "deadbeef" },
	{ string.rep("a", 40), string.rep("a", 40) },
	{ "abc123", "" },
	{ string.rep("a", 41), "" },
	{ "/etc/hosts", "/etc/hosts" },
	{ "~/src/main.lua", "~/src/main.lua" },
	{ "./src/main.lua", "./src/main.lua" },
	{ "./src/some/long/path/main.lua", "./src/some/long/path/main.lua" },
	{ "../src/main.lua", "../src/main.lua" },
	{ "src/main.lua", "src/main.lua" },
	{ "/etc", "/etc" },
	{ "and/or", "and/or" },
	{ "no hints here", "" },
}
for _, case in ipairs(cases) do
	assert_match(case[1], case[2])
end

local wrappers = { { '"', '"' }, { "'", "'" }, { "`", "`" }, { "<", ">" }, { "(", ")" }, { "[", "]" }, { "{", "}" } }
for _, wrapper in ipairs(wrappers) do
	for _, text in ipairs({ "https://example.com/a", "src/main.lua" }) do
		assert_match(wrapper[1] .. text .. wrapper[2], text)
	end
end

print("Passed")
