+++
title = "re4-pick-a-gun Server Setup"
date = "2025-05-02T09:26:17-05:00"
#dateFormat = "2006-01-02" # This value can be configured for per-post date formatting
tags = ["Dev", "Golang", "Gorilla Mux", "REST"]
slug = "server-setup"
+++

# Let's carve a path for the REST API

We've made a big move in moving everything into packages for the pick-a-gun service. Now we want to use the `core` package and use those function to build a REST API. 

## Design

For this implementation, I want to use Gorilla mux, a tried and true request and router dispatcher. I can build routes easily and more importantly, middleware is easy to plug in(more on that later.)

| Route | Description |
| -------------- | --------------- |
| `/start` | Creating the initial struct with an Ada or Leon parameter and the client will get the gun data. |
| `/roll` | Client will send it's json and the server will unmarshall it and roll for a weapon using the existing json data. |
| `/load` | Client will receieve a json to get unmarshalled to save/load progress from the website. |


This will be a good start for now. The API will always be stateless and the clients should or can get a json to keep sending back and forth. 

## Lettuce Begin

Our main function will have the mux router setup and we'll have the handlers.

```go
func main() {
	r := mux.NewRouter()
	r.HandleFunc("/start", StartHandler).Methods("GET")
	r.HandleFunc("/roll", rollHandler).Methods("POST")
	r.HandleFunc("/load", loadHandler).Methods("POST")
	http.ListenAndServe(":8080", r)
}
```

### Start Handler

Start handler will simply send a request to start the game. Since I'm testing for now, I'll hardcode the parameter in here for ada and all the default weapons to start with. 

```go
func StartHandler(w http.ResponseWriter, r *http.Request) {
	sd := core.SaveData{}
	sd.StartGame("L", core.Handguns, core.Shotguns, core.Rifles, core.Subs, core.Magnums)
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(sd)
}
```

Pretty simple stuff, We use core to create the SaveData and call `StartGame()`. This function will later accept a request param.

### Roll Handler

Roll handler will take an existing SaveData Json, decode it to see if it can fit into the struct and call it's function. This is some very risky business as someone can send all sorts of funny things in the payload so I'll require validation. 

```go
func rollHandler(w http.ResponseWriter, r *http.Request) {
	sd := core.SaveData{}
	err := json.NewDecoder(r.Body).Decode(&sd)
	if err != nil {
		http.Error(w, "Invalid JSON", http.StatusBadRequest)
		return
	}
	if sd.CurrentChapter == sd.FinalChapter {
		http.Error(w, "All out of chapters, stranger!", http.StatusOK)
		return

	}
	sd.RollGun()
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(sd)
}
```

### Load Handler

Realistically, I'm not seeing a use case for this other than the client "knowing" where it is in the game. It's still a use case though and we'll add the handler that will 

```go
func loadHandler(w http.ResponseWriter, r *http.Request) {
	sd := core.SaveData{}
	requestBytes, err := io.ReadAll(r.Body)
	if err != nil {
		http.Error(w, "Invalid Payload Data, unable to load", http.StatusBadRequest)
	}
	defer r.Body.Close()
	sd.LoadString(requestBytes)
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(sd)
}
```

#### Back to the Core

Core doesn't have a `LoadString` function, I'll quickly edit so now we have two choices of loading the data wether it's from IO or a byte array received over the wire. I might work on this error. 

```go
// LoadString will parse a byte array for unmarshalling into the struct. Mostly used in API requests.
func (s *SaveData) LoadString(data []byte) error {
	err := json.Unmarshal(data, &s)
	if err != nil {
		return fmt.Errorf("ERROR: Invalid payload")
	}
	return nil
}
```

Now, I have the choice to either commit and tag this code and pull the newer version in `comms` but I don't want to push something that needs to be tested or worked on. Great chance to use the replace directive in my comms package.

In `comms/go.mod` I'll add this to the bottom to make the package point to the local directory instead of using the downloaded package. 

`replace github.com/jorge-sepulveda/re4-pick-a-gun/core => ../core/`

This is one of my favorite features in go when it comes to package management. You can download a package, make your own changes and use that instead. It makes troubleshooting dependencies easily when an API makes some breaking changes. 

## I have fought, I won, now I REST

For testing this I'm going to use Insomnia, a nice open source alternative to Postman. It doesn't have all the rich features. We'll spin up the server and send some payloads. We got it going! One big thing missing, LOGS. The server is just a black box that takes data but I have no idea what it's up to! We'll solve this by what I think is injecting software straight into the request, otherwise called middleware. Here's a small demo. 

{{< youtube GErzellgKE0 >}}


