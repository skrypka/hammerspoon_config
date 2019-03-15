hs.logger.defaultLogLevel="info"
local reload_watcher = hs.pathwatcher.new(hs.configdir, hs.reload):start()

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.repos.skrypka = {
  url = "https://github.com/skrypka/Spoons",
  desc = "Skrypka's spoon repository",
}
spoon.SpoonInstall.use_syncinstall = true

-- defeat paste blocking
hs.hotkey.bind({"alt", "cmd"}, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

hs.grid.setGrid('2x2')
hs.grid.ui.showExtraKeys = true
hs.hotkey.bind({"alt", "cmd"}, "G", function() hs.grid.show() end)

hs.hints.style = "vimperator"
hs.window.animationDuration = 0

-- Window Movement
hs.hotkey.bind({"alt", "cmd"}, "Left", function() hs.window.focusedWindow():moveToUnit(hs.layout.left50) end)
hs.hotkey.bind({"alt", "cmd"}, "Right", function() hs.window.focusedWindow():moveToUnit(hs.layout.right50) end)
hs.hotkey.bind({"alt", "cmd"}, "Up", function() hs.window.frontmostWindow():maximize() end)
hs.hotkey.bind({"alt", "cmd"}, "Down", function() hs.window.frontmostWindow():minimize() end)
hs.hotkey.bind({"alt", "cmd"}, "f", function()
  local win = hs.window.frontmostWindow()
  win:setFullScreen(not win:isFullScreen())
end)

MouseCircle = require('MouseCircle')

spoon.SpoonInstall:andUse("MacroS", {
  start = true,
  hotkeys = {
    toggle_recording = {{"alt", "cmd"}, 'm' },
    replay_recording = {{"alt", "cmd", "shift"}, "m"},
  },
})

spoon.SpoonInstall:andUse("BingDaily", {
  repo = 'skrypka',
  start = true,
  config = { changeAllSpaces = true }
})

spoon.SpoonInstall:andUse("TextClipboardHistory", {
  start = true,
  config = { show_in_menubar = false, paste_on_select = true },
})
spoon.SpoonInstall:andUse("WifiNotifier", { start = true })
spoon.SpoonInstall:andUse("PopupTranslateSelection")
spoon.SpoonInstall:andUse("Caffeine", { start = true })

spoon.SpoonInstall:andUse("PomodoroRed", {
  start = true,
  config = {
    user_update_callback = function(status)
      local path = "/Users/roman/code/chroma/DerivedData/chroma/Build/Products/Release/chroma"
      if status == "work" then
        hs.execute(path .. " 4 1 0 0 static")
      elseif status == "relax" then
        hs.execute(path .. " 4 0 1 1 static")
      else
        hs.execute(path .. " 4 0 1 0 static")
      end
    end
  }
})

spoon.SpoonInstall:andUse("EasySuperGenPass", {
  hotkeys = {
    paste_password = {{"alt", "cmd"}, 'P' },
  },
  config = {
    save_master_password = true,
    master_passwords_hashes = {["048f"] = true}
  }
})

spoon.SpoonInstall:andUse("PushTalk", { start = true })

spoon.SpoonInstall:andUse("URLDispatcher", {
  config = {
    url_patterns = {
      { "https?://vk.com",  "com.operasoftware.Opera" },
    },
    -- default_handler = "com.google.Chrome"
    default_handler = "org.mozilla.firefox"
  },
  start = true
})

function clearFileAttributes(paths, flagTables)
  for i, path in ipairs(paths) do
    if flagTables[i].itemCreated and flagTables[i].itemIsFile then
      hs.execute('xattr -r -c "' .. path .. '"')
    end
  end
end
local folderWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/Downloads/", clearFileAttributes):start()


function openWithFinder(path)
  os.execute('open '..path)
  hs.application.launchOrFocus('Finder')
end

spoon.SpoonInstall:andUse("RecursiveBinder")
singleKey = spoon.RecursiveBinder.singleKey
hs.hotkey.bind({}, 'F19', spoon.RecursiveBinder.recursiveBind({
  [singleKey('space', 'Hints')] = hs.hints.windowHints,
  [singleKey('/', 'Mic Toggle')] = function() spoon.PushTalk.toggle_states({3, 4}) end,
  [singleKey('f', 'file+')] = {
     [singleKey('d', 'Download')] = function() openWithFinder('~/Downloads') end,
  },
  [singleKey('i', 'insert+')] = {
    [singleKey('e', 'Emoji')] = function() hs.eventtap.keyStroke({"control", "cmd"}, "space") end,
  },
  [singleKey('l', 'language+')] = {
    [singleKey('d', 'Dictionary')] = function() hs.application.launchOrFocus('Dictionary') end,
    [singleKey('u', 'to UA')] = function() spoon.PopupTranslateSelection:translateSelectionPopup("uk") end,
    [singleKey('e', 'to EN')] = function() spoon.PopupTranslateSelection:translateSelectionPopup("en") end,
  },
  [singleKey('p', 'project+')] = {
    [singleKey('h', 'Hammerspoon')] = function() hs.execute("code ~/code/hammerspoon", true) end,
    [singleKey('d', 'Dotfiles')] = function() hs.execute("code ~/code/dotfiles", true) end,
  },
  [singleKey('t', 'toggle+')] = {
    [singleKey('m', 'MouseCircle')] = function() MouseCircle:toogle() end,
  },
  [singleKey('a', 'app+')] = {
     [singleKey('a', 'ActivityMonitor')] = function() hs.application.launchOrFocus('Activity Monitor') end,
     [singleKey('t', 'iTerm')] = function() hs.application.launchOrFocus('iTerm') end,
     [singleKey('v', 'Visual Studio Code')] = function() hs.application.launchOrFocus('Visual Studio Code') end,
     [singleKey('e', 'Emacs')] = function() hs.application.launchOrFocus('Emacs') end,
     [singleKey('m', 'Mail')] = function() hs.application.launchOrFocus('Thunderbird') end,
     [singleKey('b', 'Firefox')] = function() hs.application.launchOrFocus('Firefox') end,
     [singleKey('c', 'Chrome')] = function() hs.application.launchOrFocus('Google Chrome') end,
     [singleKey('s', 'Slack')] = function() hs.application.launchOrFocus('Slack') end,
     [singleKey('f', 'Feed')] = function() hs.execute("emacsclient --eval '(elfeed-update)' && emacsclient --eval '(elfeed)' && open-emacs", true) end,
  },
  [singleKey('h', 'hammerspoon+')] = {
     [singleKey('c', 'Console')] = function() hs.console.hswindow():focus() end,
     [singleKey('r', 'Reload config')] = hs.reload,
     [singleKey('v', 'ClipboardHistory')] = function() spoon.TextClipboardHistory:toggleClipboard() end,
     [singleKey('m', 'Replay Macro')] = function() spoon.MacroS.manyReplayRecording() end,
  }
}))
