+++
title = "Time and Tagging in Hugo"
date = 2024-12-07T17:07:45-06:00
draft = false
tags = ["Hugo", "Dev"]
+++

## Timestamping files in Hugo

Time, one of our most precious resources and what I believe to be a computers worst enemy. 

When I worked at American Express, one of the biggest challenges of a real time payment system is keeping track of all the different time zones and daylight savings times.

I proposed scrapping all of that and moving everything to UTC with Unix Nanoseconds, the best way for computers to keep track of time. I was met with silence in the room and the meeting moved on but I stand by what I said!

Today, my current time pickle was timestamping these blog posts. I couldn't rely on `yyyy-mm-dd` anymore because that won't work on files with the same date. 

Hugo uses ISO8601 for it's timestamps. Still far from the supreme Unix seconds timestamps but I digress. Adding this time to my markdown file will let Hugo sort my posts!

`date = 2024-12-06T17:07:45-06:00`

## Tagging sites in Hugo

I initially wanted to seperate my posts by the type(Dev, Sysadmin and Blog for starters) and found how useful tags are. Hugo makes it really to tag files and the theme handles querying posts by a tag type. I can make different types of posts and keep it in one folder!

### Bringing it all together

On the beginning of the Hugo markdown we specify the post title, tags and time. By adding these, the posts will be sorted by time and we can use tags to "search" specific tags. This works perfectly for now, but I think down the road I'll try to implement a search feature.

```
+++
title = "Time and Tagging in Hugo"
date = 2024-12-06T17:07:45-06:00
draft = false
tags = ["Hugo", "Dev"]
+++
```

Nice little way of sorting my files and categorizing them.


