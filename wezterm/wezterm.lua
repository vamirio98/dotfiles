---@type Wezterm
local wezterm = require('wezterm')
local act = wezterm.action

-- hold the configuration
local conf = wezterm.config_builder()

-- ui {{{ --

-- Initial size
conf.initial_cols = 102
conf.initial_rows = 28

-- font {{{ --
conf.font = wezterm.font_with_fallback({
  { family = 'JetBrainsMonoNL NFM' },
  { family = 'Microsoft YaHei UI' },
})
-- }}} font --

-- tab bar {{{ --
-- https://wezterm.org/config/appearance.html#tab-bar-appearance-colors
conf.tab_bar_at_bottom = true
conf.use_fancy_tab_bar = true

-- tab title {{{ --
---@param s string
local function progname(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

-- prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab
---@param tab TabInformation
local function get_tab_title(tab)
  local title = tab.tab_title
  -- if the table titile is explicitly set, that
  if title and #title > 0 then
    return title
  end
  -- otherwise, use the title from active pane in that tab
  return progname(tab.active_pane.foreground_process_name)
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local title = get_tab_title(tab)
    local index = ""
    if #tabs > 1 then
      index = string.format('[%d] ', tab.tab_index + 1)
    end

    -- ensure that the titles fit in the available source,
    -- and that we have room for edges
    --title = wezterm.truncate_right(title, max_width - 2)
    title = ' ' .. index .. title .. ' '

    return { { Text = title } }
  end
)
-- }}} tab title --

-- }}} tab bar --

-- color scheme {{{ --
-- change light/dark according to the system theme
local function get_sys_appearance()
  return wezterm.gui and wezterm.gui.get_appearance() or 'Light'
end
local function choose_color_scheme(appearance)
  return appearance:find('Light') and 'GruvboxLight' or 'GruvboxDark'
end
conf.color_scheme = choose_color_scheme(get_sys_appearance())
-- }}} color scheme --

-- launch program {{{ --
-- default shell and working directory
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  conf.default_prog = { 'pwsh' }
end
conf.default_cwd = wezterm.home_dir

-- launch menu
local launch_menu = {}
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  table.insert(launch_menu, {
    label = 'pwsh',
    args = { 'pwsh.exe' },
  })

  -- wsl
  table.insert(launch_menu, {
    label = 'fedora',
    args = { 'wsl.exe', '-d', 'fedora', '--cd', '~' },
  })

  -- visual studio {{{ --
  -- find installed visual studio version(s) and add their
  -- complilation environment prompts to the menu
  for _, vsvers in
    ipairs(
      wezterm.glob('Microsoft Visual Studio/20*', 'C:/Program Files')
    )
    do
      local year = vsvers:gsub('Microsoft Visual Studio/', '')
      table.insert(launch_menu, {
        label = 'x64 Native Tools VS ' .. year,
        args = {
          'cmd.exe',
          '/k',
          string.format(
            'C:/Program Files/%s/Professional/Common7/Tools/VsDevCmd.bat',
            vsvers
          ),
          '-startdir=none',
          '-arch=x64',
          '-host_arch=x64'
        }
      })
    end
  -- }}} visual studio --
end
conf.launch_menu = launch_menu
-- }}} launch program --

conf.enable_scroll_bar = false

-- }}} ui --

-- keymap {{{ --
local keys = {
-- rename current tab {{{ --
  {
    key = 'r',
    mods = 'CTRL|SHIFT',
    action = act.PromptInputLine({
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be 'nil' if hit escape without entering anything
        -- an empty string if just hit enter
        -- or the actual line of text
        if line then
          window:active_tab():set_title(line)
        end
      end)
    })
  },
-- }}} rename current tab --
}
-- select tab {{{ --
for i = 1, 8 do
  table.insert(keys, {
    key = tostring(i),
    mods = 'ALT',
    action = act.ActivateTab(i - 1)
  })
end
-- }}} select tab --

conf.keys = conf.keys or {}
for _, key in ipairs(keys) do
  table.insert(conf.keys, key)
end

-- }}} keymap --

-- misc {{{ --
conf.audible_bell = "Disabled"
conf.use_ime = true
conf.use_dead_keys = false
-- }}} misc --

return conf
