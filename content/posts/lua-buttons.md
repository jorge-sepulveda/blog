+++
date = '2024-12-21T16:31:17-06:00'
draft = false
title = 'Time to add buttons to Clay-Bang'
tags = ["Lua", "Love2D", "GameDev"]
+++


It is time to add some menu functionality to Clay Bang. I had followed a previous tutorial creating some buttons and running them in `main.lua`

![pretty meh](/img/oldbuttons.png)

This is good, but I want these to be centered. These are my three buttons in `menu.lua`. They will help with state management too. 

```lua
self.buttons = {
  {text = "Start Game", x = 100, y = 100, width = 200, height = 50, action = function() State = "play" end},
  {text = "Settings", x = 100, y = 200, width = 200, height = 50, action = function() State = "SettingsMenu" end},
  {text = "Quit", x = 100, y = 400, width = 200, height = 50, action = function() love.event.quit() end},
}
```

In games, you are able to resize your window to different resolutions. How am I supposed to click if I only have a 30x30 monitor? 

I'm going to grab the screen dimensions using loves internal function.

```lua
W, H = love.graphics.getDimensions()
```

And now I can add this to dynamically center the buttons, no matter the resolutions. Ben Eater can play this on his handmade graphics card if he wanted to. 

```lua
local bXLocation = W/2
local bYLocation = H/2
self.buttons = {
  {text = "Start Game", x = bXLocation-100, y = bYLocation-300, width = 200, height = 50, action = function() State = "play" end},
  {text = "Settings", x = bXLocation-100, y = bYLocation-200, width = 200, height = 50, action = function() State = "SettingsMenu" end},
  {text = "Quit", x = bXLocation-100, y = bYLocation-100, width = 200, height = 50, action = function() love.event.quit() end},
}
```

just a little bit of addition and subtracting accounting for the button's size and we now have a main menu! I might do some button scaling in the future for some real dynamic buttons. 

![look at the awesome creation](/img/newbuttons.png)


