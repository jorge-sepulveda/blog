+++
title = "Actual Finance Showcase"
date = "2025-07-19T15:56:22-05:00"
slug = "actual-showcase"
tags = ["Docker","Actual Budget"] 
#dateFormat = "2006-01-02" # This value can be configured for per-post date formatting
+++

# Setting up my finances...the cool way 😎

I've embarked on a journey to manage my finances better, 6 months late is still fine huh? I had started something in Python but eventually left that one to collect dust in favor of learning Actual Finance. It's a docker container that will spin up an app for you to create accounts, categorize finances and help you budget. It strictly follows YNAB(You need a budget) principles but you can configure it to just track expenses, I'm good with that since all I want to do is be mindful of my expenses and making choices to bring down a specific category like restaurants(it's always food with me) 

## CSV's or API's?

Once I downloaded and spun up the container, I started importing some CSV's and categorizing them. It takes an initial time investment, but Actual gets smarter with the more data it has. You can set payee's to be auto categorized so all of my favorite restaurants and grocery stores don't need manual identification on my end. The big challenge was importing the data. Having several credit cards was tough to manage so having to download several CSV's to import them was tedious. Luckily, Actual had something already planned for me.

### SimpleFIN

One of the biggest features available was syncing my data online. It was called SimpleFIN, or the Simple Financial Interchange. They deal with getting read-only and yes, READ ONLY access to your financial accounts. They have open source components and they have even hired security audits to build confidence in people who have never heard of it like me. 

They connect to your bank using MX, a Plaid competitor so credentials stay with MX and SimpleFIN requests the data from connected institutions. For 1.50 a month, you can connect several banks back to Actual and sync the data that way, completely eliminating my CSV hassle. I was hesitant about paying for this service for a while, but 10 years back when I used quicken, they we're happy with connecting to my banks for free, because my data is well worth the cost. 

## Actual in action

Now that I have SimpleFIN connected, the rest is history. All I have to do is spin up my container and sync my account.

I have built the following graphs with some at a glance spending reports for easy visualization

{{<image src="/img/actual-update/Graphs.png" position="center">}}

And for a really big tabular view, Actual also provides that.

{{<image src="/img/actual-update/reports.png" position="center">}}

You're seeing what I think is my favorite part, the privacy filter! You can keep the amounts hidden in case you're doing your finances in public. When you hover your mouse over it, the amount will show. 

If you're like me and have no idea how to start budgeting, give this a shot. It's helped me make some more informed decisions and shape my spending habits. You can see my categories sure but wouldn't you say this is pretty generic? 45.5 percent of American households have at least one dog so good luck figuring out how much a dog costs to me. 

And that's Actual in a nutshell. Now that I got it setup with SimpleFIN, the whole process is easy and pretty fun too! 
