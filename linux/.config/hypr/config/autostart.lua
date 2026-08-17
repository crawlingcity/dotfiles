-- Auto-start config
-- if you dont use UWSM add your auto start programs here, otherwise use XDG autostart https://wiki.archlinux.org/title/XDG_Autostart

hl.on("hyprland.start", function ()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("xhost +SI:localuser:root")

    -- Session applications. Window rules place these on their assigned workspaces.
    hl.exec_cmd("uwsm app -- /home/crawling/Downloads/zen/zen")
    hl.exec_cmd("uwsm app -- steam")
    hl.exec_cmd("uwsm app -- ghostty")

    -- The portrait monitor's Dwindle layout splits top-to-bottom. Start Discord
    -- after Zen and preselect the lower half so their placement is deterministic.
    hl.timer(function ()
        hl.dispatch(hl.dsp.focus({ window = "class:zen" }))
        hl.dispatch(hl.dsp.layout("preselect d"))
        hl.exec_cmd("uwsm app -- discord")
    end, { timeout = 5000, type = "oneshot" })
end)
