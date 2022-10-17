hs.logger.defaultLogLevel = "info"
local reload_watcher = hs.pathwatcher.new(hs.configdir, hs.reload):start()

require("hs.ipc")

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.repos.skrypka = {
  url = "https://github.com/skrypka/Spoons",
  desc = "Skrypka's spoon repository"
}
spoon.SpoonInstall.use_syncinstall = true

-- defeat paste blocking
hs.hotkey.bind(
  {"alt", "cmd"},
  "V",
  function()
    hs.eventtap.keyStrokes(hs.pasteboard.getContents())
  end
)

hs.grid.setGrid("2x2")
hs.grid.ui.showExtraKeys = true
hs.hotkey.bind(
  {"alt", "cmd"},
  "G",
  function()
    hs.grid.show()
  end
)

hs.hints.style = "vimperator"
hs.window.animationDuration = 0

-- Window Movement
hs.hotkey.bind(
  {"alt", "cmd"},
  "Left",
  function()
    hs.window.focusedWindow():moveToUnit(hs.layout.left50)
  end
)
hs.hotkey.bind(
  {"alt", "cmd"},
  "Right",
  function()
    hs.window.focusedWindow():moveToUnit(hs.layout.right50)
  end
)
hs.hotkey.bind(
  {"alt", "cmd"},
  "Up",
  function()
    hs.window.frontmostWindow():maximize()
  end
)
hs.hotkey.bind(
  {"alt", "cmd"},
  "Down",
  function()
    hs.window.frontmostWindow():minimize()
  end
)
hs.hotkey.bind(
  {"alt", "cmd"},
  "f",
  function()
    local win = hs.window.frontmostWindow()
    win:setFullScreen(not win:isFullScreen())
  end
)

spoon.SpoonInstall:andUse(
  "TextClipboardHistory",
  {
    start = true,
    config = {show_in_menubar = false, paste_on_select = true}
  }
)
spoon.SpoonInstall:andUse("PopupTranslateSelection")

hs.caffeinate.set("displayIdle", true, true)
spoon.SpoonInstall:andUse("Caffeine", {start = true})

spoon.SpoonInstall:andUse(
  "EasySuperGenPass",
  {
    repo = "skrypka",
    hotkeys = {
      type_url_paste_password = {{"alt", "cmd"}, "P"}
    },
    config = {
      save_master_password = true,
      master_passwords_hashes = {["048f"] = true}
    }
  }
)

spoon.SpoonInstall:andUse(
  "PushToTalk",
  {
    start = true,
    config = {
      app_switcher = {["zoom.us"] = "push-to-talk"}
    }
  }
)

spoon.SpoonInstall:andUse("MouseCircle", {repo = "skrypka"})

spoon.SpoonInstall:andUse(
  "URLDispatcher",
  {
    config = {
      url_patterns = {
        {"https?://*.rainforestqa.*", "com.google.Chrome"},
        {"https?://*.accounts.google.com", "com.google.Chrome"},
        {"https?://*.dropbox.*", "com.google.Chrome"},
        {"https?://*.zoom.us", "com.google.Chrome"},
        {"https?://avo.app", "com.google.Chrome"}
      },
      default_handler = "org.mozilla.firefox"
    },
    start = true
  }
)

xattrTimer =
  hs.timer.doEvery(
  60 * 60 * 8,
  function()
    hs.execute("xattr -c -r ~/Downloads")
  end
)

function openWithFinder(path)
  os.execute("open " .. path)
  hs.application.launchOrFocus("Finder")
end

---===--- Text substitution ---===---
-- Focus the last used window.
local function focusLastFocused()
  local wf = hs.window.filter
  local lastFocused = wf.defaultCurrentSpace:getWindows(wf.sortByFocusedLast)
  if #lastFocused > 0 then
    lastFocused[1]:focus()
  end
end
-- On selection, copy the text and type it into the focused application.
local chooser =
  hs.chooser.new(
  function(choice)
    if not choice then
      focusLastFocused()
      return
    end
    hs.pasteboard.setContents(choice["subText"])
    focusLastFocused()
    hs.eventtap.keyStrokes(hs.pasteboard.getContents())
  end
)
chooser:choices(
  {
    {
      ["text"] = "Наша Зброя\n",
      ["subText"] = "Наша зброя в цей момент - вподобайка на комент!"
    },
    {
      ["text"] = "Героям Слава\n",
      ["subText"] = "Героям Слава! Наша зброя в цей момент - вподобайка на комент."
    },
    {
      ["text"] = "ostapyurko@yahoo.com\n",
      ["subText"] = "ostapyurko@yahoo.com"
    }
  }
)
---===--- END Text substitution ---===---

spoon.SpoonInstall:andUse("RecursiveBinder")
singleKey = spoon.RecursiveBinder.singleKey
hs.hotkey.bind(
  {},
  "F19",
  spoon.RecursiveBinder.recursiveBind(
    {
      [singleKey("space", "Hints")] = hs.hints.windowHints,
      [singleKey("/", "Mic Toggle")] = function()
        spoon.PushToTalk:toggleStates({"push-to-talk", "release-to-talk"})
      end,
      [singleKey("s", "Text Substitution")] = function()
        chooser:show()
      end,
      [singleKey("f", "file+")] = {
        [singleKey("d", "Download")] = function()
          openWithFinder("~/Downloads")
        end
      },
      [singleKey("i", "insert+")] = {
        [singleKey("e", "Emoji")] = function()
          hs.eventtap.keyStroke({"control", "cmd"}, "space")
        end
      },
      [singleKey("l", "language+")] = {
        [singleKey("d", "Dictionary")] = function()
          hs.application.launchOrFocus("Dictionary")
        end,
        [singleKey("u", "to UA")] = function()
          spoon.PopupTranslateSelection:translateSelectionPopup("uk")
        end,
        [singleKey("e", "to EN")] = function()
          spoon.PopupTranslateSelection:translateSelectionPopup("en")
        end
      },
      [singleKey("p", "project+")] = {
        [singleKey("h", "Hammerspoon")] = function()
          hs.execute("code ~/code/hammerspoon", true)
        end,
        [singleKey("d", "Dotfiles")] = function()
          hs.execute("code ~/code/dotfiles", true)
        end
      },
      [singleKey("t", "toggle+")] = {
        [singleKey("m", "MouseCircle")] = function()
          spoon.MouseCircle:toggle()
        end
      },
      [singleKey("a", "app+")] = {
        [singleKey("a", "ActivityMonitor")] = function()
          hs.application.launchOrFocus("Activity Monitor")
        end,
        [singleKey("t", "iTerm")] = function()
          hs.application.launchOrFocus("iTerm")
        end,
        [singleKey("v", "Visual Studio Code")] = function()
          hs.application.launchOrFocus("Visual Studio Code")
        end,
        [singleKey("e", "Emacs")] = function()
          hs.application.launchOrFocus("Emacs")
        end,
        [singleKey("m", "Mail")] = function()
          hs.application.launchOrFocus("Thunderbird")
        end,
        [singleKey("b", "Firefox")] = function()
          hs.application.launchOrFocus("Firefox")
        end,
        [singleKey("c", "Chrome")] = function()
          hs.application.launchOrFocus("Google Chrome")
        end,
        [singleKey("s", "Slack")] = function()
          hs.application.launchOrFocus("Slack")
        end,
        [singleKey("f", "Feed")] = function()
          hs.execute("emacsclient --eval '(elfeed-update)' && emacsclient --eval '(elfeed)' && open-emacs", true)
        end
      },
      [singleKey("h", "hammerspoon+")] = {
        [singleKey("c", "Console")] = function()
          hs.console.hswindow():focus()
        end,
        [singleKey("r", "Reload config")] = hs.reload,
        [singleKey("v", "ClipboardHistory")] = function()
          spoon.TextClipboardHistory:toggleClipboard()
        end,
        [singleKey("m", "Replay Macro")] = function()
          spoon.MacroS.manyReplayRecording()
        end
      }
    }
  )
)
