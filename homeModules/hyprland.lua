-- ── NVIDIA Wayland ───────────────────────────────────────────────────────────
hl.env("LIBVA_DRIVER_NAME",        "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME","nvidia")

-- ── Variables ────────────────────────────────────────────────────────────────
local mainMod = "SUPER"

-- ── Autostart ────────────────────────────────────────────────────────────────
hl.on("hyprland.start", function()
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("waybar")
  hl.exec_cmd("mako")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("swayosd-server")
  -- Clipboard history daemon: records every copy into ~/.cache/cliphist/db
  hl.exec_cmd("wl-paste --watch cliphist store")
end)

-- ── Visual settings ───────────────────────────────────────────────────────────
hl.config({
  cursor = {
    no_hardware_cursors = true,  
  },
  general = {
    gaps_in    = 6,
    gaps_out   = 20,
    border_size = 3,
    ["col.active_border"]   = "rgb(cba6f7)", -- mauve (catppuccin)
    ["col.inactive_border"] = "rgb(585b70)", -- grey (catppuccin)
  },
  decoration = {
    rounding    = 4,
    dim_around  = 0.75,
  },
  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo   = true,
  },
  dwindle = {
    preserve_split = true,
  },
  input = {
    sensitivity   = -0.1,
    accel_profile = "flat",
  },
})

-- ── Animations ────────────────────────────────────────────────────────────────
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1   }, { 0.32, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5,  0.5 }, { 0.75, 1 } } })
hl.curve("quick",        { type = "bezier", points = { { 0.15, 0   }, { 0.1,  1 } } })

hl.animation({ leaf = "windows",     enabled = true, speed = 4,   bezier = "easeOutQuint", style = "popin 85%" })
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 4,   bezier = "easeOutQuint", style = "popin 85%" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 2,   bezier = "quick" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4,   bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "border",      enabled = true, speed = 5,   bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 3,   bezier = "quick" })
hl.animation({ leaf = "fadeDim",     enabled = true, speed = 3,   bezier = "quick" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 3.5, bezier = "almostLinear", style = "slide" })

-- ── Layer rules ───────────────────────────────────────────────────────────────
hl.layer_rule({ dim_around = true, match = { namespace = "wofi" } })
hl.layer_rule({ dim_around = true, match = { namespace = "wlogout" } })

-- ── Keybinds ──────────────────────────────────────────────────────────────────

-- Applications
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + R",      hl.dsp.exec_cmd("wofi --show drun"))
-- Clipboard history picker: fuzzy-search past copies, re-copies the selection
hl.bind(mainMod .. " + C",      hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy"))

-- Window management
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprctl dispatch killactive"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))

-- Mouse binds (drag to move / resize floating windows)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Screenshots (no PRINT key on 60% keyboards)
-- SUPER+P       → full screen, saved to ~/Pictures/Screenshots/
-- SUPER+SHIFT+S → region select, piped straight to clipboard
hl.bind(mainMod .. " + P",          hl.dsp.exec_cmd("grim ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png"))
hl.bind(mainMod .. " + SHIFT + S",  hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))

-- Session
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))

-- Volume / brightness (XF86 media keys via swayosd)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume raise"))
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume lower"))
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"))
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness raise"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"))
hl.bind("F5",                    hl.dsp.exec_cmd("swayosd-client --brightness lower"))
hl.bind("F6",                    hl.dsp.exec_cmd("swayosd-client --brightness raise"))

-- Focus movement
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Window movement (SUPER+SHIFT+arrows)
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))

-- Workspaces 1–9
-- SUPER+N        → switch to workspace N
-- SUPER+SHIFT+N  → move focused window to workspace N (stay on current workspace)
-- SUPER+CTRL+N   → move focused window to workspace N AND follow it there
for i = 1, 8 do
  local key = tostring(i)
  hl.bind(mainMod .. " + " .. key,              hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key,      hl.dsp.window.move({ workspace = i }))
  hl.bind(mainMod .. " + CTRL + " .. key,       hl.dsp.window.move({ workspace = i, follow = true }))
end
