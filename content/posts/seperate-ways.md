+++
title = "Adding Seperate Ways to Re4-Pick-A-Gun"
date = "2025-04-10T14:45:18-05:00"
#dateFormat = "2006-01-02" # This value can be configured for per-post date formatting
tags = ["Dev", "FyneUI", "Golang"]
+++

## Dusting off the RE4 pick-a-gun service

It's been a while since I've touched the pick a gun service. It was a project that started when I was playing Re4 Remake for hours. I wanted to use a random weapon that would only be used for that chapter. It was a nice way to spice up the runs and not use pen and paper to keep track of my runs. Out of sheer laziness, the pick a gun service was born. Built with Go, FyneIO and a lotta love. 

I want to go over the existing design as it hasn't been cared for a while and break down the new plans I have.

## System breakdown

### Core
The core is built on some organic, homegrown Go. This is the main API of the project. It handles the gun picking, and saves and loads data into a struct I built for keeping track of the chapter and weapons used. For now, it only handles Leon's weapons, which is something I'll talk about further in the post. Core is the backbone and there are two ways to use this API. 

### CLI

There is a command line interface used for interacting with the service. Using different commands, you can interact with the system and save your progress. The file is saved into a json which can of course be easily modified if for some reason you don't like your pick or hack the file...you have that choice. I'm a big nerd that loves the terminal so this is my favorite way of using the pick a gun service. 

### UI

I came across the FyneUI library a while ago and it is extensive. It follows material design and it's easy to make UIs. Same as the CLI, the UI calls on core's functions to work and do the same actions like save and load. I loaded bundled resource for the images so you can see the weapon too! 


## The plan

### What about Bob?!(Ada)

I was too invested in playing normal runs of Seperate Ways that I forgot that the core has to change to fit the fun, single weapon runs. This means the API and the core needs to change a little. Luckily, small modifications are needed. Let's start with core. All the info that gets saved gets stored in this struct. Now, I need to include a character but that can be a single char. Go doesn't use chars as the string implementation revolves around their fancy slices. I could use a rune or a byte but this is a single char I'm adding. It would make sense if I was trying to same some space but a humble `string` will do. I'll sacrifice some extra bytes in memory for an easier implementation. If I'm using a string, I might as well go ahead and use the name instead of single letters. Makes the json readable too. 


Now that the final chapter can either be 16 or 7 depending on the playthrough, we'll include that in the struct to help with the math. 

```go
// SaveData
type SaveData struct {
	SelectedCharacter string   `json:"selected_character"`
	CurrentChapter    int      `json:"current_chapter"`
	FinalChapter      int      `json:"final_chapter"`
	CurrentGun        string   `json:"current_gun"`
	UsedGuns          []string `json:"used_guns"`
	GunsList          []string `json:"guns_list"`
}

```

### Weapons list

I was using several string arrays to build the weapon list when rolling. I set it up this way because it will let me disable some guns for an upcoming feature. I added Ada's weapons to the list. We see some duplicates here but that works in my favor with using the same image resource in the UI so we'll keep it. 

```go
var (
	Handguns = []string{"SR-09 R", "Punisher", "Red9", "Blacktail", "Matilda", "Sentinel Nine"}
	Shotguns = []string{"W-870", "Riot Gun", "Striker", "Skull Shaker"}
	Rifles   = []string{"SR M1903", "Stingray", "CQBR Assault Rifle"}
	Magnums  = []string{"Broken Butterfly", "Killer7"}
	Subs     = []string{"TMP", "LE 5"}
	//Idon'tlikethisone = [string]{"Bolt Thrower"}
	Specials    = []string{"Handcannon", "Infinite Rocket Launcher", "Chicago Sweeper"}
	AdaHandguns = []string{"Blacktail AC", "Punisher MC", "Red9"}
	AdaShotguns = []string{"Sawed-off W-870"}
	AdaRifles   = []string{"SR M1903", "Stingray"}
	AdaSubs     = []string{"TMP"}
	AdaSpecials = []string{"Infinite Rocket Launcher", "Chicago Sweeper", "Blast Crossbow"}
)
```

### Starting the game

Now, we only need one more change to handle character selection. In fact, I might even get away with setting the parameter in the function definition and use that to decide who's playing. I'll the final chapter struct field and use that struct field instead of the max chapter const. This will affect the load file as well but we'll change it to use that after unmarshalling. Nice part about this too is that I'm giving more control to the save file. 


```go
func (s *SaveData) StartGame(pick string, guns ...[]string) error {
	if pick == "L" {
		s.SelectedCharacter = "Leon"
		s.FinalChapter = 16
	} else if pick == "A" {
		s.SelectedCharacter = "Ada"
		s.FinalChapter = 7
	}

	s.CurrentChapter = STARTCHAPTER
	for i := range guns {
		s.GunsList = append(s.GunsList, guns[i]...)
	}
	//error check in the event there aren't enough guns for all the chapters.
	if len(s.GunsList) < s.FinalChapter {
		return fmt.Errorf("ERROR: Not enough guns in the pool")
	}
	rand.Shuffle(len(s.GunsList), func(i, j int) {
		s.GunsList[i], s.GunsList[j] = s.GunsList[j], s.GunsList[i]
	})
	s.GunsList = s.PickGun()
	return nil
}
```

And there we go! Just a few changes in some specific places and the API should handle seperate ways. Last thing I'll need to add an "L" to the `StartGame` function so I don't break the UI or the CLI while making fixes. This will make it backwards compatible as I bake in the remaining changes. 

This wasn't that bad an effort. I only had to change 3 lines across the CLI and the UI and I kept everything working. I might start itching to do another run again...

Biggest takeaway here is the modularization is what saved me. Keeping core doing everything saved me a few headaches and the CLI is my tool for testing to make sure it's ready for the UI. Next time we'll tackle the CLI. 


