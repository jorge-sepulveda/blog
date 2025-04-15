+++
title = "Changing cursor and adding sound effects to Clay-Bang"
date = "2025-04-09T20:17:30-05:00"
#dateFormat = "2006-01-02" # This value can be configured for per-post date formatting
tags = ["GameDev", "Lua", "Love2d", "Dev"]
+++

# Adding some feedback mechanisms to the game

Clay bang has been getting pretty fun. I started managing states to pause the game to make it feel more like a game. Something I've been wanting to do for a while is changing the cursor to a crosshair and adding a muzzle sound while clicking. 

I downloaded an open source muzzle sound and created my crosshair using my ipad. I wanted to make the muzzle modular so I'm loading it in a seperate file. 

I created `muzzle.lua` and loaded the resources. 

## Creating a modular sound file

```go
function Muzzle.load()
    Muzzle.image = love.graphics.newImage("assets/guneffect.png")
    Muzzle.sound = love.audio.newSource("assets/sounds/gun.wav", "static")
end

function Muzzle.show()
    Muzzle.x, Muzzle.y = love.mouse.getPosition() -- Get mouse position
    Muzzle.active = true
    Muzzle.timer = Muzzle.duration
end

function Muzzle.update(dt)
    if Muzzle.active and State == "play" then
        Muzzle.timer = Muzzle.timer - dt
        if Muzzle.timer <= 0 then
            Muzzle.active = false
        end
    end
end

function Muzzle.draw()
    if Muzzle.active and State == "play" then
        Muzzle.sound:play()
        love.graphics.draw(
            Muzzle.image,
            Muzzle.x, Muzzle.y,
            0,
            Muzzle.scale, Muzzle.scale,
            Muzzle.image:getWidth() / 2, Muzzle.image:getHeight() / 2
        )
    end
end
```

Just like we do in Love, set up load, show, update and draw. I want to play this sound everytime a click was made. 

## Replacing the cursor

The cursor is a trickier choice. You can either make your mouse invisible and replace it with the crosshair image as you move. The alternative is to use Love's function for replacing the cursor. The latter takes less resources as you'd be replacing the actual cursor instead of constantly drawing it. I went with replacing the crosshair directly in `main.lua`

inside of `love.load` we'll add the cursor function

```go
local customCursor = love.mouse.newCursor("assets/crosshairs.png", 24, 24)
love.mouse.setCursor(customCursor)
```

Muzzle will be called in all the main function after initializing. 


## The Pre-Pre Alpha

It's been fun making clay bang. I can see the vision for adding the intended roguelike elements and maybe some networking involved as well. I recorded some footage of it and published it to Youtube. It's been a lot of learning too! Games are pretty complex sometimes but it's fun when you're making something you like to play. 

Cursor messed up for some reason so I may have to reconsider drawing it.

{{< youtube bq32QgWJd9E >}}

