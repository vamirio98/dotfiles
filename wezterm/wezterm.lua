-- pull in the wezterm API
local wezterm = require('wezterm')

-- hold the configuration
local conf = wezterm.config_builder()

-- ui {{{ --

-- Initial size
conf.initial_cols = 102
conf.initial_rows = 28

-- font {{{ --
conf.font = wezterm.font_with_fallback({
  'JetBrainsMonoNL NFM',
  'Microsoft YaHei UI',
})
-- }}} font --

-- tab bar {{{ --
-- https://wezterm.org/config/appearance.html#tab-bar-appearance-colors
conf.tab_bar_at_bottom = true
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
conf.default_cwd = '~'

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

-- }}} ui --

return conf
