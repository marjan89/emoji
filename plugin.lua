---@type PluginDefinition
return {
	metadata = {
		name = "emoji",
		version = "1.0.0",
		icon = "󰞅",
		description = "Emoji picker with clipboard support",
		platforms = { "macos", "linux" },
	},

	tasks = {
		pick = {
			name = "Pick Emoji",
			description = "Search and copy an emoji to your clipboard",
			mode = "none",
			exit_on_execute = true,

			item_sources = {
				emojis = {
					tag = "e",
					items = function()
						local path = syntropy.expand_path("./emojis.txt")
						local file = io.open(path, "r")

						if not file then
							return { "Error: emojis.txt not found at " .. path }
						end

						local items = {}
						for line in file:lines() do
							if line ~= "" and not line:match("^%s*$") then
								table.insert(items, line)
							end
						end
						file:close()

						if #items == 0 then
							return { "Error: No emojis found in emojis.txt" }
						end

						return items
					end,

					preview = function(item)
						-- Parse TSV format: emoji\tdescription\tkeywords
						local parts = {}
						for part in item:gmatch("[^\t]+") do
							table.insert(parts, part)
						end

						if #parts < 2 then
							return "Invalid format"
						end

						local emoji = parts[1] or ""
						local description = parts[2] or ""
						local keywords = parts[3] or ""

						return string.format(
							"Emoji: %s\n\nDescription: %s\n\nKeywords: %s",
							emoji,
							description,
							keywords
						)
					end,

					execute = function(items)
						if #items == 0 then
							return "Error: No emoji selected", 1
						end

						local selected = items[1]

						-- Extract emoji (first field before tab)
						local emoji = selected:match("^([^\t]+)")

						if not emoji or emoji == "" then
							return "Error: Could not parse emoji from selection", 1
						end

						-- Try clipboard commands in order of preference
						local clipboard_commands = {
							{ "pbcopy", "pbcopy" }, -- macOS
							{ "xclip", "xclip -selection clipboard" }, -- Linux X11
							{ "xsel", "xsel -i -b" }, -- Linux X11
							{ "wl-copy", "wl-copy" }, -- Wayland
						}

						for _, cmd_pair in ipairs(clipboard_commands) do
							local test_cmd = cmd_pair[1]
							local full_cmd = cmd_pair[2]

							-- Check if command exists
							local _, test_code = syntropy.shell("command -v " .. test_cmd .. " >/dev/null 2>&1")

							if test_code == 0 then
								-- Use printf instead of echo for better emoji handling
								local copy_cmd = string.format("printf '%%s' '%s' | %s", emoji, full_cmd)
								local _, code = syntropy.shell(copy_cmd)

								if code == 0 then
									return string.format("✓ Copied %s to clipboard", emoji), 0
								end
							end
						end

						return "Error: No clipboard tool found (tried pbcopy, xclip, xsel, wl-copy)", 1
					end,
				},
			},
		},
	},
}
