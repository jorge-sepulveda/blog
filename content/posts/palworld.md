+++
title = "Troubleshooting Palworld on Manjaro"
date = "2025-03-09T21:46:28-05:00"
tags = ["Gaming", "Manjaro"]
readingTime = true
+++

# Finally moving to Linux

After several years of gaming on Windows, I have finally made the move to using Linux, specifically Arch btw... Since I don't have the TPM module 2014 motherboard, I had to decide wether to do linux or just buy a new computer. I've been using Ubuntu for several years and using it in WSL. I wanted to try out rolling releases and all the headaches that can come with it cause it creates opportunities for learning. 

## Plans for the PC

I plan to use the desktop as a server for my media and a personal cloud. My approach here will be docker with kubernetes. This way the OS can continue updating and the docker containers will be on fixed versions. There'll be more posts about that at a later time. 

## Gaming

I have a 1070 in the system that doesn't do AAA as well but it can still play some games. Thanks to SteamOS, there has been a lot of progress and support for gaming on Linux. I have gotten away with using enabling compatibility with Proton. So far I'm happy to say Civ 5, Rise of Nations(great RTS by the way), and PlateUp has worked well for me. The one weird one that I came across was Palworld. Every time it started up, the Vulkan shaders would seem to stall and the game would never start. I believed this was the beginning of the journey for gaming on Linux. 

### The solution

After seeing a few forums, the solution is relatively simple. First off, close steam entirely. Then, go into the command line and type this command.

`steam`

This will start steam you can open Palworld normally. While it is weird to have to do it from the command line, my best guess is that the terminal has more access to wine callables than the regular steam application does. I'll have to investigate further but if it works, I'll take it. 

## Takeaway

I'm pretty stubborn sometimes when people say I should upgrade my hardware. I decide when to decommission my technology so I will go the painful route of doing this and I hope my findings help fellow Manjaro users when gaming. If you have the option to go to Windows 11, take it. It'll be a lot easier. If valve decides to sell SteamOS or even better, open source it, I will delete everything I have and use that insteas. It's a really good OS and even Lenovo is putting on their game pads because of how good it is. 
