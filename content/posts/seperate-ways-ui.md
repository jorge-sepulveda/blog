+++
title = "Updating image bundles in Fyne UI"
date = "2025-04-22T09:49:37-05:00"
tags = ["Dev", "FyneUI", "Golang"]
+++

# Time to get this through the finish line

When I added to the API, I set the table. When I updated the CLI, I fired up the grill. Tonight, when I update my UI, I will feast. So far the development has been smooth. The API required minimal changes so the CLI and UI we're easy to work on. Only thing I needed to do was update the images and add some buttons for character selection. 

## Time to bundle Joint Photographic Experts Groups

To get the new weapon images, I used a crawler. The crawler was named Jorge and he likes to eat food and play games. Not as efficient as using beautiful soup but I was successful in getting the new 5 image I needed online. When packaging images with Fyne, you have to bundle the images into a binary executable and reference the variables in your code. This is a much handier way of giving your users a folder full of JPEG's with each executable you share. 

I added the folders into the `img` folder with names like `BlackTail_AC.JPEG`. Nice and easy to use, even more easier when referencing. 

Now that I had the images downloaded,I resized them using good ol' imageMagick and I rerun the bundle command. There is a way to append the existing images into the existing bundle but I'm not gonna worry about bundling 15 images. 

`fyne bundle -o bundled.go img/`

Here's a small snippet of what code looks like inside.


```go
var resourceBlackTailACJPEG = &fyne.StaticResource{
	StaticName: "BlackTail_AC.JPEG",
	StaticContent: []byte(
		"\xff\xd8\xff\xe0\x00\x10JFIF\x00\x01\x01\x00\x00\x01\x00\x01\x00\x00\xff\xfe\x002JPG 
converted with https://ezgif.com/webp-to-jpg\xff\xdb\x00C\x00\x03\x02\x02\x03\x02\x02\x03\x03\x03\x03\x04\x03\x03\x04\x05\b\x05\x05\x04\x04\x05\n\a\a\x06\b\f\n
\f\f\v\n\v\v\r\x0e\x12\x10\r\x0e\x11\x0e\v\v\x10\x16\x10\x11\x13\x14\x15\x15\x15\f\x0f\x17\x18\x16\x14\x18\x12\x14\x15
\x14\xff\xdb\x00C\x01\x03\x04\x04\x05\x04\x05\t\x05\x05\t\x14\r\v\r\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x
14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\x14\xff\xc0\x00\x11\b\x03\xaf\x04\xd8\x03\x01\"\x00\x02\x11\x01\x03\x11\x01\xff\xc4\x00\x1e\x0
0\x01\x00\x02\x02\x03\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x04\x02\x05\x01\x06\a\t\b\n\xff\xc4\x00j\x1
0\x00\x02\x01\x03\x03\x02\x04\x03\x05\x06\x03\x04\x05\x03\x00+\x01\x02\x03\x00\x04\x11\x12
!1\x05A\x06\x13\"Q\aaq\x142\x81\x91\xa1\b\t#B\xb1\xf0\x15\xc1\xd1\x16R\xe1\xf1\x19$3b\xd4\x174r\x94\xb4&CEv\x82\x9
3\xa4\xc4\x18%'78FTVds\x84\xc3\xd35DSUeftu\x95\xa36Wc\x92\xb3\x83\x86\x96\xa2\xb2\xff\xc4\x00\x18\x01\x01\x01\x01\
x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x02\x03\x04\xff\xc4\x00(\x11\x01\x01\x01\x00\x02\x02\x
03\x00\x02\x02\x02\x03\x01\x01\x00\x00\x00\x01\x11\x021\x12!...
```

Can you see that it's the top part of the image? Me too!

The bundle command grabs the picture data and turns it into a byte array for easy reconstruction. It even contains the "converted with" text in the header. Pretty nice and sneaky way of embedding data since I needed to convert it from a PNG first. This can then be put in Git and packaged into executables. Pretty handy library.

## Referencing the images
This was a tricky problem when I was working on Leon's weapons. I need reference the string and then link it to the Fyne Static Resource Object that contains the picture data for rendering. Basically, the string of the weapon selected should control which image gets displayed. Maps came to the rescue here. I created a map of strings and Fyne Static resources. This is why I was ok with having duplicate weapon names in Ada's weapons arrays because it could already reference those images. I added five more in the map. 

{{< highlight go "linenos=inline, hl_lines=22-26" >}}
var gunMap = map[string]*fyne.StaticResource{
	"SR-09 R":                  resourceInfiniteRocketLauncherJPEG,
	"Punisher":                 resourcePunisherJPEG,
	"Red9":                     resourceRed9JPEG,
	"Blacktail":                resourceBlacktailJPEG,
	"Matilda":                  resourceMatildaJPEG,
	"Sentinel Nine":            resourceSentinelNineJPEG,
	"W-870":                    resourceW870JPEG,
	"Riot Gun":                 resourceRiotGunJPEG,
	"Striker":                  resourceStrikerJPEG,
	"Skull Shaker":             resourceSkullShakerJPEG,
	"SR M1903":                 resourceSRM1903JPEG,
	"Stingray":                 resourceStingrayJPEG,
	"CQBR Assault Rifle":       resourceCQBRAssaultRifleJPEG,
	"Broken Butterfly":         resourceBrokenButterflyJPEG,
	"Killer7":                  resourceKiller7JPEG,
	"TMP":                      resourceTMPJPEG,
	"LE 5":                     resourceLE5JPEG,
	"Handcannon":               resourceHandcannonJPEG,
	"Infinite Rocket Launcher": resourceInfiniteRocketLauncherJPEG,
	"Chicago Sweeper":          resourceChicagoSweeperJPEG,
	"Blast Crossbow":           resourceBlastCrossbowJPEG,
	"Sawed-off W-870":          resourceSawedOffW870JPEG,
	"Blacktail AC":             resourceBlackTailACJPEG,
	"Punisher MC":              resourcePunisherMCJPEG,
	"Black":                    resourceBlackJPEG,
}
{{< /highlight >}}

Once this was in place the `updateLabels` function takes care of the rest. Anytime a new weapon is rolled it gets the resource from the map and then it loads the image. I added a black image for some safety to avoid memory violations(getting c++ segfault flashbacks). Now that we're waiting from input wether Leon or Ada will get picked, I need to "prime" the image resource by loading a default black image. I should change this to a gray background instead and make it "invisible."

## Let's add some buttons
First I need to update my `updateLabels` function. This handles updating the image when you click "roll." 

{{< highlight go "linenos=inline, hl_lines=1 4-5" >}}
func updateLabels(g *widget.Label, c *widget.Label, p *widget.Label, gi *canvas.Image, sd *core.SaveData) {
	c.SetText(fmt.Sprintf("Current Chapter: %d", sd.CurrentChapter))
	g.SetText(fmt.Sprintf("Current Gun: %s", sd.CurrentGun))
	p.SetText(fmt.Sprintf("Selected Character: %s", sd.SelectedCharacter))
	newImage := canvas.NewImageFromResource(gunMap[sd.CurrentGun])
	gi.Image = newImage.Image
	gi.File = newImage.File
	gi.Resource = newImage.Resource
	gi.Refresh()
}
{{< /highlight >}}

We'll add the new widgets for the buttons in the main function. These will call `StartGame` from `core.go`

```go
adaButton := widget.NewButton("Seperate Ways(Ada)", func() {
	err := sd.StartGame("A", core.AdaHandguns, core.AdaShotguns, core.AdaRifles, core.AdaSubs, core.AdaSpecials)
	if err != nil {
		dialog.NewError(err, w).Show()
	}
	updateLabels(gunLabel, chapLabel, characterLabel, gunImage, &sd)
})

leonButton := widget.NewButton("Main Game(Leon)", func() {
	err := sd.StartGame("L", core.Handguns, core.Shotguns, core.Rifles, core.Subs, core.Magnums)
	if err != nil {
		dialog.NewError(err, w).Show()
	}
	updateLabels(gunLabel, chapLabel, characterLabel, gunImage, &sd)
	})
```

Lastly, we'll add the two new buttons in a container and then add them to a brand new `mainMenu` container. I also added a black image so I had to update the gunImage object to reference that image before somebody starts the game. 

```go
pickPlayer := container.NewVBox(adaButton, leonButton)
textBoxes := container.NewVBox(characterLabel, chapLabel, gunLabel, gunImage)
buttonBox := container.NewVBox(rollButton, loadButton, saveButton, quitButton, textBoxes)

mainMenu := container.NewVBox(pickPlayer, buttonBox)
w.SetContent(mainMenu)
```

And there we go! The UI can now handle both seperate ways and the main playthrough. The repo is now ready for a future release when I work on some of the "feedback" when pressing some buttons. 

Here's a quick demo of it. 

{{< youtube m6WchQVVj88 >}}

## Future plans

This has been a fun project for me, it's been making my runs in Re4 more fun and I've been having fun learning Fyne. I want to make a web application out of this. Fyne allows me to build a webapp but I want to make a stateless REST API. The API will send the updated json and the client will hold onto it for saving/loading. 


