+++
date = '2024-12-15T18:56:25-06:00'
draft = false
slug = 'link-shortcodes'
title = 'Hugo Shortcodes Pt. 3'
tags = ["Hugo", "Dev"]
+++

# Finally, a shortcode worth making

I have returned with a shortcode that ended up being pretty handy for me. 

When using links with Hugo in Markdown I can use `[text to display](url)` to display the links and it works. It's clickable, it takes you to the site, nothing wrong with it. 

Me being me of course, couldn't overlook the simple thing that the URL's don't take you to another tab. What is this, the 90s? 

## HTML URLS

The common cause for this is an HTML one. When Hugo handles URL's in my markdown files they use the default target, which is `_self`. This means the url will open in the same tab that it's open. 

## Shortcodes to the rescue

I could go into this terminal theme's HTML/CSS files and manually add the target to my desired one, `_blank`. That would be more of a hack as I'd be editing my themes files and I would have to remember to fix that every time I update the git submodule. 

I also don't want all my links to go to a new tab. I want URL's that link to my other blog posts to stay within my blog and external links to go to a new tab. 

### The link shortcode 

I've created a new file in my shortcodes called `link.html` and created this one liner. An a tag that will take the url parameter 

```html
<a href={{.Get "href"}} target="_blank">{{.Inner}}</a>
```

Same as before, I reference it in my markdown like so. Again using an image as I can't seem to stop the link getting process by Hugo even when surrounded by ticks. 

![link shortcode](/img/linkshortcode.png)

And there we have it! A really easy shortcode that only does one thing and one thing only. It renders URL's and takes you to a new tab when you click. And to fully christen the usage, I'll leave the link to a relevant XKCD. 

Now all I have to do is quietly update the repo to use these links when necessary. 

{{<link href="https://xkcd.com/1144/">}}
Relevant XKCD 
{{</link>}}

