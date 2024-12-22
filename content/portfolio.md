+++
title = "Portfolio"
+++

## Personal Projects

Out of the hundreds of stale repos I have from school, I will display the recent projects I've been working on in the past year. Sorry React, those old school projects won't be displayed here.

### Clay Bang

Dipping my toes into Game Development here. I love skeet shooting but I've only done it like 5 times. What if I want to make my own roguelike skeet shooting game and have the fun at home?

This is made with Lua and Love2d, an extensive framework with a physics engine as well.

Goal of the game is to click on all the pigeons. Accurate shots in the center will lead to crits. The most challenging part was well, learning physics all over again. I have complete control of the pigeons flight path and can predict where they will land. That was essential for troubleshooting seeds down the road.

Things I want to add is making different types of clays(ARMORED CLAY) and different types of weapons with upgraded damage. 

For now, here is a small demo of clay bang, clicking on the pigeons until they just dissapear from the screen. 

The redlines are the predicted heights and distances that the pigeon will fly. 

{{<image src="/img/clay-bang.gif" alt="200 hours, there I said it." width="700px" position="center">}}

### The Resident Evil 4 Pick-A-Gun Service

Repo Link:[https://github.com/jorge-sepulveda/re4-pick-a-gun](https://github.com/jorge-sepulveda/re4-pick-a-gun)

Ever since Resident Evil 4 Remake came out, I have poured more hours than I want to admit playing it. It got to the point that I wanted to make the pick-a-gun service so I could randomly select a gun to only use for that chapter. I made this using Go and Fyne UI, an elegant graphics library made in Go. 

The service rolls for a weapon, saves/loads from a json and you can make an exclusion list for anybody who wants to do a pistol only or shotgun run. 

Easy to use, extensive documentation and even cross compatible. I can easily port this to Windows and make a Web App!

{{<image src="/img/re4new.png" width="700px" position="center">}}


## Research Paper

Link to ISPRS Archives: https://isprs-archives.copernicus.org/articles/XLIV-M-2-2020/95/2020/

In 2019 I was taking a Global Navigation Satellite System(GNSS) class I leaded my team ambitious project. My teammate had access to caves and we explored if we can 3D map a cave. Turns out, it is possible!

This took on multiple disciplines, from photogrammetry drone flight paths, structure from motion to make 3d models and LIDAR Point Clouds. 

With our learnings, we went underground and took pictures of both sides of the cave and later converted them to point clouds.

These point clouds we're later converted to a format that was compatible with the Unity Game Engine. 

The end result is a game where you are inside the cave and you can walk around it! 

Our paper was later submitted to the International Society for Photogrammetry and Remote Sensing(ISPRS) and it was peer reviewed and published during the Summer of 2020. 

{{<image src="/img/fig1.png" width="700px" position="center">}}
{{<image src="/img/fig2.png" width="700px" position="center">}}
{{<image src="/img/fig3.png" width="700px" position="center">}}
