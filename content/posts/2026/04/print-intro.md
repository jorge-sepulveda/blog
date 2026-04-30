+++
title = "The Joys of Painti- Uuuh 3D Printing!"
date = "2026-04-01T21:54:37-05:00"
authorTwitter = "" #do not include @
cover = ""
tags = ["3D Printing", "OpenSCAD"]
slug = "print-intro"
keywords = ["", ""]
description = ""
showFullContent = false
readingTime = true
+++

# You wouldn't print a car

I have broken down and finally got a 3D printer. I've been printing all sorts of things and getting sucked in to Reddit forums, YouTube tutorials and more. This thing is amazing! All sorts of printable items in a 256 cubic millimeter space and multiple colors, the only thing limiting me is my imagination. We'll try to expand on that. 

## 3D Modelling Software

Now that I know how to print items from the community, I want to take the next step and design my own prints to solve some real problems. So I started looking around for 3D modelling software. I thought I could draw from my experience as a proud and certified Autodesk Inventor user. 

I thought about giving Fusion a try but something different came along, something open source, with no GUI's and no million buttons requiring me to poke around. 

### Along came OpenSCAD

{{<link href="https://openscad.org/about.html">}}OpenSCAD{{</link>}} is my kind of CAD software. It uses a scripting language to generate the models and with variables you can do all sorts of things like more teeth in a gear, paramatized spacing and more. If you want a cube all you have to do is define its' dimensions with `cube(10)` and bam, you get a cube. No skething and extrusion necessary, you get what you asked for.

## The problem

The dishwasher in our new apartment is kinda small for it's size, causing the dishwasher to either move side to side or tip over if you pulled it. There are usually metal tabs on top but what about the sides? Something must be done, something... must be printed...let's get cracking.

### The approach

Using openscad, I printed a small shim with a tab at the end: 

```openscad
// Define a small overlap to ensure a clean union
eps = 0.01;
union() {
    cube(size=[40,20,10]);
    translate([35,0,10-eps])
    cube(size=[5,20,10],);
}
```


{{<image src="/img/Wedge_v1.png" width="700px" position="center">}}


## The result..inconclusive.

I had pushed this into the sides of the dishwasher and it solved the side-to-side swaying...until I loaded it and pulled it, tabs too. I think what I really need is a bracket...more to follow. 


 




