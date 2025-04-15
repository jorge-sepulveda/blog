+++
title = "Seperate Ways ClI"
date = "2025-04-11T10:53:54-05:00"
#dateFormat = "2006-01-02" # This value can be configured for per-post date formatting
tags = ["Dev", "Golang"]
+++

# Time to update the beautiful text on the terminal

In my [previous post](./seperate-ways.md), I changed the core API to handle Ada's Seperate Ways playthrough. Here we'll be updating the CLI to handle the new API functionality. I want to add an option where the user can hit `l` or `a` to start either playthrough. Let's make some changes

## While I write this code...wait, where's my while?! 

Currently, I'm using a for loop to scan user input and use the API. The only way of getting out is by hitting `q` or `ctrl+c`. Now I'll add another loop scanning for input on the start game conditions, wether it will be Ada or Leon. The funny thing I encountered here is that the switch automatically breaks but only out of the switch, it won't get out of the for loop. I'm using a `ready` boolean to say when it's ready to break free of the for loop. Why did Google not add `while` to Golang? Cause `for` is there! 

Google, I love golang a lot. I like the simple keywords and easy readability, but come on! 

Rant over. We'll add `ready` in our main function:
{{< highlight go "hl_lines=3" >}}
	var sd core.SaveData
	var option string
	var ready = false
{{< /highlight >}}


And now we'll add the for loop of the first scan of inputs. 

{{< highlight go "linenos=inline, hl_lines=5-19" >}}
	for {
		fmt.Scan(&option)
		fmt.Println("Choose your option, Stranger: ")
		switch option {
		case string('l'):
			fmt.Println("Starting leon's playthrough...")
			err := sd.StartGame("L", core.Handguns, core.Shotguns, core.Rifles, core.Subs, core.Magnums)
			if err != nil {
				print(err.Error() + "\n")
				os.Exit(1)
			}
			ready = true
		case string('a'):
			fmt.Println("Starting Ada's playthrough...")
			err := sd.StartGame("A", core.AdaHandguns, core.AdaShotguns, core.AdaRifles, core.AdaSubs, core.AdaSpecials)
			if err != nil {
				print(err.Error() + "\n")
				os.Exit(1)
			}
			ready = true
		case string('q'):
			fmt.Println("Quit command sent.")
			os.Exit(0)
		case string('h'):
			fmt.Println("Printing Help.")
			fmt.Println("a to roll for Seperate Ways")
			fmt.Println("l to roll Main playthrough")
			fmt.Println("q to quit app")
		}
		if ready {
			break
		}
	}
{{< /highlight >}}

With this added, the user now will now choose Leon or Ada and then you can roll for weapons like normal. The CLI is now ready to handle the new API changes. Now we can start working on the UI. I'll download some of the new JPEGS for Ada's weapons and we'll learn a little bit of Fyne. 

