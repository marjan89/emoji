# Emoji Plugin

A syntropy plugin for quickly searching and inserting emojis. Browse through 1,869 emojis with intuitive keyword search, preview descriptions before selecting, and automatically copy to your clipboard. Supports macOS (pbcopy) and Linux (xclip, xsel, wl-copy). Simple, fast, and seamlessly integrated into your syntropy workflow.

## Features

- **Fast emoji search**: Search through 1,869 emojis by description and keywords
- **Live preview**: See emoji details, descriptions, and keywords before selecting
- **Automatic clipboard copying**: Selected emoji is instantly copied to your clipboard
- **Cross-platform support**: Works on macOS and Linux with multiple clipboard tools
- **Simple interface**: Single "Pick Emoji" task for quick access

## Usage

1. Launch the emoji picker through syntropy
2. Search for emojis using descriptions or keywords (e.g., "smile", "heart", "celebration")
3. Preview emoji details before selecting
4. Select an emoji to copy it to your clipboard
5. Paste the emoji anywhere with your clipboard (Cmd+V / Ctrl+V)

## Installation

Add to your syntropy configuration:

```toml
[plugins.syntropy-emoji]
git = "https://github.com/marjan89/emoji.git"
tag = "v1.0.0"
```

## Requirements

The plugin requires a clipboard utility to be installed on your system:

- **macOS**: `pbcopy` (included by default)
- **Linux (X11)**: `xclip` or `xsel`
- **Linux (Wayland)**: `wl-copy`

The plugin will automatically detect and use the first available clipboard tool.

## Technical Details

### Emoji Database

The plugin uses a TSV (tab-separated values) file format for the emoji database (`emojis.txt`):

```
emoji   description   keywords
```

**Example entries:**
```
😀	grinning face	smile,happy
❤️	red heart	love,emotion
🎉	party popper	celebration,party
```

The database contains 1,869 emojis with comprehensive descriptions and searchable keywords.

### Plugin Structure

- `plugin.lua` - Main plugin implementation
- `emojis.txt` - Emoji database (64 KB, 1,869 entries)
- `README.md` - This documentation file

## Version

**Version**: 1.0.0

## License

MIT License - see [LICENSE](LICENSE) file for details.
