# Media Assets

Place your addon's media files in this directory:

## Supported Formats

- **Icons**: `.tga` (Targa) or `.blp` (Blizzard Texture) - 32x32 or 64x64 recommended
- **Textures**: `.tga` or `.blp` - any power-of-2 dimensions
- **Sounds**: `.ogg` (Vorbis) format

## File Paths

Reference media files using the full path:

```lua
local iconPath = "Interface\\AddOns\\HelloRGX\\media\\icon"
```

## Creating Icons

1. Create a 32x32 or 64x64 image in your preferred editor
2. Save as `.tga` with 32-bit color (RGBA)
3. Place in this folder
4. Reference in code: `"Interface\\AddOns\\HelloRGX\\media\\myicon.tga"`

## Using SharedMedia

If RGX-Framework's SharedMedia module is available, you can register custom assets:

```lua
local SM = RGX:GetModule("sharedmedia")
if SM then
    SM:Register("background", "HelloRGX_BG", "Interface\\AddOns\\HelloRGX\\media\\background")
end
```
