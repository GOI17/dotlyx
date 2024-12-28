local wezterm = require("wezterm")
local act = wezterm.action

local function is_inside_vim(pane)
  local tty = pane:get_tty_name()
  if tty == nil then return false end

  local success, stdout, stderr = wezterm.run_child_process
      { 'sh', '-c',
        'ps -o state= -o comm= -t' .. wezterm.shell_quote_arg(tty) .. ' | ' ..
        'grep -iqE \'^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$\'' }

  return success
end

local function is_outside_vim(pane) return not is_inside_vim(pane) end

local function bind_if(cond, key, mods, action)
  local function callback(win, pane)
    if cond(pane) then
      win:perform_action(action, pane)
    else
      win:perform_action(act.SendKey({ key = key, mods = mods }), pane)
    end
  end

  return { key = key, mods = mods, action = wezterm.action_callback(callback) }
end

local config = {
  default_prog = {
    "/bin/zsh",
    "-l",
  },
  font = wezterm.font("CaskaydiaCove Nerd Font", { bold = true }),
  font_size = 12.0,
  color_scheme = "tokyonight_moon",
  use_fancy_tab_bar = false,
  enable_tab_bar = true,
  tab_bar_at_bottom = true,
  hide_tab_bar_if_only_one_tab = true,
  window_decorations = "RESIZE",
  warn_about_missing_glyphs = false,
  keys = {
    bind_if(is_outside_vim, 'h', 'CTRL', act.ActivatePaneDirection('Left')),
    bind_if(is_outside_vim, 'j', 'CTRL', act.ActivatePaneDirection('Down')),
    bind_if(is_outside_vim, 'k', 'CTRL', act.ActivatePaneDirection('Up')),
    bind_if(is_outside_vim, 'l', 'CTRL', act.ActivatePaneDirection('Right')),
    -- {
    --   key = "h",
    --   mods = "CTRL",
    --   action = act.ActivatePaneDirection("Left"),
    -- },
    -- {
    --   key = "l",
    --   mods = "CTRL",
    --   action = act.ActivatePaneDirection("Right"),
    -- },
    -- {
    --   key = "k",
    --   mods = "CTRL",
    --   action = act.ActivatePaneDirection("Up"),
    -- },
    -- {
    --   key = "j",
    --   mods = "CTRL",
    --   action = act.ActivatePaneDirection("Down"),
    -- },
    {
      key = "h",
      mods = "CTRL|ALT",
      action = act.SplitPane({
        direction = "Left",
      }),
    },
    {
      key = "l",
      mods = "CTRL|ALT",
      action = act.SplitPane({
        direction = "Right",
      }),
    },
    {
      key = "k",
      mods = "CTRL|ALT",
      action = act.SplitPane({
        direction = "Up",
      }),
    },
    {
      key = "j",
      mods = "CTRL|ALT",
      action = act.SplitPane({
        direction = "Down",
      }),
    },
    {
      key = "c",
      mods = "CTRL|SHIFT",
      action = act.SpawnTab("CurrentPaneDomain"),
    },
    {
      key = "w",
      mods = "CTRL|SHIFT",
      action = act.ShowTabNavigator,
    },
    {
      key = "c",
      mods = "CTRL|SHIFT",
      action = act.SpawnTab("CurrentPaneDomain"),
    },
    {
      key = "w",
      mods = "CTRL|SHIFT",
      action = act.ShowTabNavigator,
    },
  },
}

return config
