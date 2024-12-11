+++
date = '2024-12-10T19:26:30-06:00'
draft = false
title = 'Learning Shortcodes in Hugo'
tags = ['Hugo', 'Dev']
+++

# Pictures are worth a thousand words

I wanted to start adding some content to my showcase and thought of displaying an image of the repository with some text next to it. Sounds easy enough, right?

The Hugo framework is amazing, really fast and really easy to add content. In other posts, I was ok with slapping the image on it but encountered some limitations with needing to modify the images.

Normally in Markdown, if you need to edit an image, you could add HTML in there with some styling properties.

`<img src="drawing.jpg" alt="drawing" width="200"/>`

However, Hugo doesn't parse this since it does it's own HTML generation and there's a setting that disallows this. Fair enough, Hugo.

## Using libraries

After consulting search engine oracles, I found there was a library called the [Hugo Images Module](https://images.hugomods.com/) and it can do a lot. Resizing, filtering, aligning and a few more things, sneakily replacing the Hugo syntax for images with it's own style for additional settings. 

I was following the alignment tutorial as I need a floating image on the left with text on the right, but the website was suggesting using shortcodes to complete this. WHAT'S A SHORTCODE?!

## Hugo is stronger than I realized

Shortcodes are custom templates you can apply to a section of the markdown files. It's intended to solve having to add HTML in the files when you need some pizzazz in the files. After removing the hugo mod I created and putting my files back(Thanks Git!), I got cracking.

## The requirements for the new shortcode

The shortcode needs to do two things. It needs to take an image and put in the left side of the screen. On the right side, the text would be next to the image displaying a simple column format. 

Some extras are passing in parameters to control the size of the image so the text isn't left with 10 pixels to render.

We create our little section below. I have a div using flex to display the image and the text with some extra CSS to render. I placed this in my layouts called `floatimage.html`

```html
<div style="display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: 15px;">
  <div style="flex: 0 0 50%; max-width: 50%; margin-right: 15px;">
    <img 
      src="{{ .Get "src" }}" 
      alt="Image description" 
      style="width: 100%; height: auto;">
  </div>
  <div style="flex: 0 0 50%; max-width: 50%; text-align: left; word-wrap: break-word; overflow-wrap: break-word; white-space: normal; margin-top:100px">
    {{ .Inner }}
  </div>
</div>
<div style="clear: both;"></div>
```
Afterwards, we go back to markdown and the shortcode in here.

```
{{<floatimage src="/img/snippet.png" alt="alt-text">}}
I can't put the snippet because Hugo will render it, but this is what I'm going for.
{{< /floatimage >}}
```

And that's pretty much it!Still needs parameters and I know this is a lot of flex magic going on so I *should* put this in a CSS file, but that will be for a different time. Tonight I'll bask in the victory of figuring out some shortcodes.

