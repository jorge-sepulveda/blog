+++
title = "Clay Damage Calculation"
date = "2025-11-30T13:55:21-06:00"
slug = 'clay-damage'
tags = ["GameDev", "Dev", "Lua", "Love2D"]
+++

# Damage System in Clay Bang

I've been reviewing the existing damage system in Clay-Bang. For roguelikes, all enemies must have health, ergo these clays have health. In real life, your aim depends on how the pigeon will break. If you clipped it on the edge, that means you hit the nose. And then there's the more satisfying shot, hitting it in the middle completely vaporizes the clay and your aim was dead on. This is my approach to simulate those kind of shots. 

## First Approach : Grids

At first, I thought about starting with a 3x3 grid over the pigeon and calculating damage that way. 

![Initial Grid design for damage](/img/clay-grids.png)

This seemed clever at first but first hump was figuring out the corner shots. Hitting the center would be a crit, either applying double the damage or just destroying the clay entirely. 

## Use the circle, Luke

In Skeet shooting, hitting the center completely deletes the pigeon so why not do that?! I can get the position of the pointer and I always have the clay's position when it's clicked. A little bit of Euclidean distance math, and I came up with this. 

```go
function Pigeon:clicked(x, y)
  local dx = x - self.body:getX()
  local dy = y - self.body:getY()
  local distance = math.sqrt(dx * dx + dy * dy)
  if distance <= self.shape:getRadius() then
    self:damageCalc(distance / self.shape:getRadius(), 100)
  end
end

function Pigeon:damageCalc(distance, power)
  if DEBUG then
    print("DEBUG::Pigeon.damageCalc()::Distance from Center: " .. distance)
  end
  if distance <= 0.35 then
    print("DEBUG::Pigeon.damageCalc()::CRIT!")
    self.health = self.health - power * 2
  else
    self.health = self.health - power
  end
  if self.health <= 0 then
    self.marked = true
  end
end

return Pigeon
```

Now, I calculate the distance from the center of the clay to the position where you clicked on the pigeon. If you click within 35 percent of the clay's center, that's double damage! Here is where I let cleanup happen too after the next refresh to make sure the clay dissapears in the next frame. My debug logs tell me my distances so I can prepare for a cool animation when I detect these crits. 


```bash
DEBUG::Pigeon.damageCalc()::Distance from Center: 0.75484508395447
DEBUG::Pigeon.damageCalc()::Distance from Center: 0.19084864321771
DEBUG::Pigeon.damageCalc()::CRIT!
```

I'm glad I went with this approach, feels more truer to the actual sport...as unreal as the game already is. 


