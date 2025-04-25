+++
date = '2024-12-11T14:32:44-06:00'
draft = false
slug = 'shortcodespt2'
title = 'Hugo Shortcodes Pt. 2'
tags = ['Hugo', 'Dev']
+++

# Riveting conclusion

In [my previous post](shortcodes.md) I had an initial tutorial for creating shortcodes. I had made a floating image with some text on the right. I thought I had succeeded, that I won. When I looked at it again the CSS styling and editing was gonna be tricky. I had lost the Markdownification that Hugo makes so my headers and text just looks like plain HTML text. fixing that would've taken me a while. 

## Don't reinvent the wheel

Just because one can make shortcodes doesn't mean they should. They are meant to be easily templatible but I had made it so complex that it was giving me issues left and right. I had removed the shortcode from my codebase after finding out that Hugo can position my content, which is the whole reason I wanted to make the shortcode.

When it comes to maintaining code bases, my senior engineer said "it's not about the code you're adding, it's about the removals," and he is so right. There are too many times when we decide to make a system more complex without giving a thought about reusability and scalability. I've definitely added code without thinking about the future ramifications and I was just doing the same thing. Luckily, I had a great senior engineer who taught me the importance of mishaps like this. 

In an amazing quote from the show Silicon Valley, Gilfoyle says that deleting all the code is "technically and statistically correct" when trying to remove bugs. The best code is no code, guys! 

I've resorted to using the classic image shortcode. No magic, clean and simple. 

