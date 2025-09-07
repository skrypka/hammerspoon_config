-- hs.logger.defaultLogLevel = "debug"
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

hs.window.animationDuration = 0

local function axHotfix(win)
  if not win then win = hs.window.frontmostWindow() end

  local axApp = hs.axuielement.applicationElement(win:application())
  local wasEnhanced = axApp.AXEnhancedUserInterface
  axApp.AXEnhancedUserInterface = false

  return function()
      hs.timer.doAfter(hs.window.animationDuration * 2, function()
          axApp.AXEnhancedUserInterface = wasEnhanced
      end)
  end
end

local function withAxHotfix(fn, position)
  if not position then position = 1 end
  return function(...)
      local revert = axHotfix(select(position, ...))
      fn(...)
      revert()
  end
end

local windowMT = hs.getObjectMetatable("hs.window")
windowMT.maximize   = withAxHotfix(windowMT.maximize)
windowMT.moveToUnit = withAxHotfix(windowMT.moveToUnit)

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

keyModal = hs.hotkey.modal.new({}, nil)
keyModal.pressed = function() keyModal:enter() end
keyModal.released = function() keyModal:exit()  end
hs.hotkey.bind({}, 'F19', keyModal.pressed, keyModal.released)
keyModal:bind({}, '/', nil, function() spoon.PushToTalk:toggleStates({"push-to-talk", "release-to-talk"}) end)
keyModal:bind({}, 'm', nil, function() hs.application.launchOrFocus("Thunderbird") end)
keyModal:bind({}, 'e', nil, function() hs.application.launchOrFocus("Emacs") end)
keyModal:bind({}, 't', nil, function() hs.application.launchOrFocus("iTerm") end)
-- keyModal:bind({}, 't', nil, function() hs.application.launchOrFocus("Ghostty") end)
keyModal:bind({}, 'c', nil, function() hs.application.launchOrFocus("Google Chrome") end)
keyModal:bind({}, 'b', nil, function() hs.application.launchOrFocus("Firefox") end)
