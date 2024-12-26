+++
title = "Showcasing the alive_progress library"
date = "2024-12-26T12:46:40-06:00"
tags = ["Dev", "Python"]
draft = false
+++


# Sure you can trust a computer, but why do that when you have progress bars? 

Have you ever ran a script that needs to do I/O on several hundred files? You want to know wether it's gonna be done now or go grab a cup of coffee? 

So what do you do? Make some print statements at the end of the loop with something like "I"M DONE WITH FILE X?" What is this, 2010? 

Previously I've been using {{<link href="https://github.com/tqdm/tqdm">}}tqdm.{{</link>}}A very robust library for progress bars. It gets the job done and has a whopping 29k stars on Github. I recently found another kind of progress bar library that I want to share. 

Here's {{<link href="https://github.com/rsalmei/alive-progress">}}alive_progress!{{</link>}}Easy to use, with ETA and throughput built in. It also has several different bars for some cool style points while you're processing. 

Let's take it for a test drive. Using the `alive_bar`, I've declared that it's processing 1000 items, using the blocks bar and the twirls spinner. 

Afterwards, I'm using a very generic for loop. For real usage, I'd replace 1000 with `len()`. To showcase one more thing, I'm going to use a print statement every 500 iterations. 

```python
from alive_progress import alive_bar
import time

with alive_bar(1000, bar='blocks', spinner='twirls') as bar:
    for i in range(1000):
        if i % 500 == 0:
            print("I'm divisible by 500!")
        time.sleep(0.01)
        bar()
```

Once we run it, this is the final result. I'll even print the number that the iteration was on and there's a lot of logging capabilities built in. There's even a pause functionality to stop and fix something if something went wrong. 

![It's alive](/img/alive.gif)


## What a nice library.

I was very happy with using TQDM, but something about the customization of the bars and spinners makes for some very satisfying outputs. I'll be using this next time I need to parse some big ol CSV's.
