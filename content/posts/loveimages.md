+++
title = "Loading backgrounds into Love2D"
date = "2025-03-11T22:49:59-05:00"
tags = ["Love2d", "GameDev"]
+++

# Bye Bye Black screen!

I've been shooting some clays on clay-bang and it's starting to look a little lifeless. Just shooting clays on a black screen, all of them with dreams and they yearn to be flown on an open range. Well, let's change that by adding a background image. I want to keep a pixelated look to the game so it had to be pixel art. There are different tools like piskel but I have an iPad just gathering dust since college. What if I used Procreate to make it? 

Turns out, it is very possible. After following an online tutorial, I created a 1 pixel block brush. I then went out to draw a 1920 by 1080 background, pixel by pixel... 

## Screen Resolutions

Around the 366th pixel, I started thinking "there has to be a better way". After visiting some forums, I found out that 360 x 640 resolutions is the most popular one. The main reason why it's so popular is because it's easily scalable. At 200%, this can fit a 720p screen and at 300% it can fit into 1080p and so on. This divided the amount of drawing I needed to do by a third! I still had to handdraw it but I was much happier this time around. 

Now we have a crudely drawn background! It was a test in patience and ended up being very relaxing as time went on. I'm very proud of it. 

![background](/img/background.png)

## Loading a background into Love2d

Now that we have our background, loading it into love2d is easy. Inside of your `main.lua` file, create the Image in `love.load()` and then call it in `draw()` I'm going to scale it since I usually do 720p if I'm not on my monitor. 

```lua
function love.load()
  Background = love.graphics.newImage("assets/background.png")
end

function love.update(dt)
end

function love.draw()
  local scaleX = love.graphics.getWidth() / Background:getWidth()
  local scaleY = love.graphics.getHeight() / Background:getHeight()
  love.graphics.draw(Background, 0, 0, 0, scaleX, scaleY)
end
```

And now we have clay bang with a background! Now that I have this on a screen, I have a bigger idea of how big I should draw this clay because this is some pretty precise clicking. Scaled nicely too! 

![Clay being is coming close to fruition!](/img/newbackground.png)

We have done it, we have given the clays the open pastures they deserve. Now we'll move on to a cursor for aiming and hitting them. 
