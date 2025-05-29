+++
title = "Open Source is still strong"
date = "2025-05-24T13:49:48-05:00"
#dateFormat = "2006-01-02" # This value can be configured for per-post date formatting
tags = ["Docker", "FOSS", "Actual Budget"]
slug = "expense-tracker-final"
+++

# The Expense Trackers Conclusion

Several months ago, I had expressed wanting to get a handle on my expenses cause I have no real budgeting techniques. After downloading all my statememts, I embarked on a journey to make my own expense tracker in Python. I had a pretty good start with a good concept and the database was fast with DuckDB. 

Of course, life happens and I got more focused on the pick a gun and some recent career shifts, the expense tracker was not getting any love. However, my problem still persists. I was watching some video with Linus Torvalds and the speaker opened that he had made Linux in the 90s and git was created in 2005. He was asked that it's been too long since he made something impactful, so when is he gonna release the next big thing? His answer was a hopeful one for developers at large. He had created his projects because he had problems and no solutions existed for it so he solved it himself. Linus, like other people who are lazy, hopes for other people to solve his problems and he hasn't felt a need to create something. 

This is true on so many levels, we often want to create new solutions but open source has solved a lot of problems. At times, we go and reinvent wheels and spend a lot of time, probably sucked in, in doing so a lot of time can be spent here. Back in December, I posted about [keeping things simple](../../2024/12/shortcodespt2.md), when I was hung up about trying to make different shortcodes for this blog. 

## One more time, no reinventing the wheel

After seeing this video, I decided to look into open source solutions for tracking expenses. Linus said it and the community provided, I had found and started using {{<link href="https://actualbudget.org/">}}Actual Budget.{{</link>}} It's a self hostable, and dockerable application. As I added transactions, Actual tries to "learn" about common patterns in your data to help create rules and you can leverage those into categories such as rent or bills. It's a pretty handy app and fulfills the privacy requirements I had when I began this effort(note: food costs money). One big feature that shined for me was the privacy button. It will overwrite monetary amounts with squiggles until you move the cursor over it. I never thought of that! I was happily categorizing transactions while waiting at the shop because even if someone looked over my shoulder, they can't see real amounts. 

## Summing it all up

I was in fact able to sum up some transactions and got a handle on tracking transactions! Open source for the win. If you're in a similar situation as I am, give Actual a try! 
