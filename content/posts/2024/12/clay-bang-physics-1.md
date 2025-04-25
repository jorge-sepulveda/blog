+++
title = "Clay Bang Physics Troubleshooting"
date = "2024-12-26T14:58:04-06:00"
author = ""
draft = false
slug = 'clay-bang-physics-1'
tags = ["GameDev", "Dev", "Lua", "Love2D"]
+++

# Oh for the love of Clay-Bang Physics

When I initially thought of making the clays fly in my game, I thought of using lines with randomized curves and making the pigeons fly along the line. 

Once I finally got to making it, Love2D has a very extensive physics engine which is a port of Box2D so I thought "What if we use physics instead?"

I believe that once humans have a complete understanding of physics, we can be the masters of our own universe. I also believe that with enough physics calculations, I can be the master of clay-bang's universe. Maybe once I finish this game I'll set my sights to dark matter research, but for now, I'll master projectile motion. 

## Breakdown of the current logic

Currently, I'm using projectile motion equations. The clays will start at a random height outside the screen, a random distance is picked and then the equations are ran to calculate how fast, what angle and the time flight. It took me 8 hours of picking up physics again and drawing equations on my whiteboard like a madman before the clay was flying where I wanted it to. I was intent on having fully predictable flight paths since I am using random seeds and it would make it leagues easier to troubleshoot. Physics will do my math for me and I will stick with this design choice. 

After setting up the menu and playing a little with a fixed random seed, I found a major bug. Some of the pigeons had a `nan` velocity. The red lines are where the clay is getting launched and the green lines are the predicted heights and distances. Don't worry, that won't be part of the final product.

![WHAT!](/img/before.gif)

## Physics is hard

Here is the formula for calculating the height of the clay's flight based on where it is and where it's going. I'm not planning to disprove physicians or mathematicians right now so we'll leave that function untouched. 

![Physics Initial vertical Velocity formula](/img/math.png)

When the desired height is greater than the initial height, this subtraction is negative and Lua can't figure out what to do with it. My pigeon gets destroyed before it even gets a chance to fly. That shouldn't be happening at all.

Currently I've used `abs` to force a positive number but now this will sometimes give my pigeon some extra oomph and it'll fly past the expected distance. This doesn't smell like "master of the clay-bang universe" to me.

Let's check the parameters causing this bug. I set up DEBUG statements early on because debugging is one thing, debugging physics is another. y1 is 173 and y2 is 253. When I plug this in, I get an IMAGINARY NUMBER! Not even mathematicians can figure this out, let alone one of the dumbest inventions of mankind, the computer. 

## A proper solution

Clearly, something is up with my pigeon positioning. I pick a random height between certain percentages of the screen's height to determine where the pigeon should spawn and how high it should go(say the launcher is 15-70% of the screen and the expected height is between 75-90%).  
After busting out my trusty TI-84, I started double checking the y positioning. It didn't take me long to figure out the bug. 

After picking the desired height, I subtract the screen height by the randomized number. 0 starts at the top of the screen so if the random function picks 810, the desired height will be 270. The clay *should* be higher than pixel-wise but I wasn't completely consistent in my math. I found out the clay is just picking something in the range but not getting subtracted, the position is completely opposite of where it should be and ending up higher than the desired height at times.

In the end, all that was needed was a one liner to do same subtraction as the desired height. I'm very happy that it was a minor fix. We are back to fully predictable flight paths. Using the same seed as before leads to much more satisfying flights.

![DONE](/img/after.gif)

