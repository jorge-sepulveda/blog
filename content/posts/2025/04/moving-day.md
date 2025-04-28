+++
title = "Moving Day! Let's create some Go packages"
date = "2025-04-28T10:10:43-05:00"
tags = ["Dev", "Golang"]
slug = "moving-day"
+++

# Restructing the repository for the pick a gun service

I have begun working on a REST API server with Gorilla for the pick a gun service and imported the core API. I realized that Fyne was getting indirectly imported even when the internal core package doesn't need it, it just runs on the standard library. 

Sure it's indirect, but I'm trying to keep Fyne in the UI. To eliminate this, I need to finally restructure the ui, cli and core into their own packages. When this started as a small project, I admittedly loosened some of my standards in exchange for faster development. The technical debt isn't bad but I should take a step back to do some general maintenance of my repo. 

Like Hank Hill says, "With the joy of responsibility, comes the burden of obligation."

## Tag you're it, core

I want the ui and cli to use a tag for the core. That way, core isn't married to any changes I make(and there shouldn't be too much changes anyway) when I make pushes. If I need to troubleshoot locally, I can always use the replace directive in my `go.mod` file.

```sh
git tag core/v1.0.1
git push origin core/v1.0.1
```

## Folder playground

Now, we'll create the ui folder and get the go packages and move the files that only belong to ui in there. I'll also rename `ui.go` to `main.go`. 

```sh
mkdir ui
cd ui
go get fyne.io/fyne/v2
go get github.com/jorge-sepulveda/re4-pick-a-gun/core
cd ..
mv bundled.go img icon.png ui.go ui/
mv ui.go main.go
```

We'll make a new makefile just for the ui and place it in that folder.

```sh
run:
	go run main.go bundled.go

build-mac:
	fyne package -os darwin -icon icon.png

build-windows:
	fyne-cross windows -output re4-pick-a-gun -arch=amd64
```

And after running `make run` the ui is still alive! We have successfully modularized the UI in the repo. Cli already had a folder so I made a `go.mod` file and got the core package. I went ahead and added the MIT license to the repo as well. 

## It is done

Now that everything is structured properly, I no longer have indirect references to packages I don't need. I can also build a `comms` package which will house my client and server files for the REST API. 
