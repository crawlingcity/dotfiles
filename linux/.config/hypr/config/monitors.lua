-- Monitor wiki https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Example: output can be found with hyprctl monitors. Edit variables.lua for the monitor outputs instead of here directly
-- hl.monitor({
--     output    = "MONITOR1",
--     mode      = "1920x1080@60",
--     position  = "0x0",
--     scale     = "1",
-- })

hl.monitor({
    output    = MONITOR1,
    mode      = "preferred",
    position  = "0x0",
    scale     = 1,
    vrr       = 2,
})

hl.monitor({
    output    = MONITOR2,
    mode      = "3840x2160@60",
    position  = "3440x-700",
    scale     = 1.5,
    transform = 1,
})
