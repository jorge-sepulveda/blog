+++
title = "Registering the blog to my domain"
date = 2024-12-07T14:26:30-06:00
tags = ["Github", "Dev"]
draft = false
+++

# Bringing jorgesepulveda.dev to life

Now that I have a blog going, it's time to use my custom domain and register it. 

## First things first

We need two things here, I need to have a website hosted somewhere and that's what Github Pages is doing right now. Secondly, we need to own a domain. 

I've owned jorgesepulveda.dev since the .dev domains became available. I originally bought it on Google Sites but it got transferred to Squarespace without my consent. Reminds me of when my student loans change providers(servicers?). I don't know, they take the payment and the feds are cool with it. 

### Squarespace Setup 

Inside of the domain you own in squarespace we must setup for A records and a final CNAME record under DNS settings. The data on the A records will be 185.199.108-111.153. I couldn't find these on WHOIS but other forums tell me that these are Github's IP addresses so adding these make sense.

Lastly, we'll set up the CNAME record which points to the default link that Github makes for your repo.

![SquareSpaceDomain Setup](/img/sqspace-domains.png)

This won't propagate immediately, we have to wait three days but I am eager to see if this works right now.

### Setting up Github

Now in the repo settings under Pages, we'll add the custom domain. Github will do a DNS check for you to make sure it's good.

![Github Pages](/img/gp-pages-setup.png)

### The dismantling of my beautiful creation

I've mentioned in my [previous blog post](dev-blog-intro.md) that I will fight Hugo sometimes, and they picked the wrong guy. After registering my site, the theme completely dissapeared and I'm left with this. Look how they massacred my boy!

![ohno](/img/broken-page.png)

### Troubleshooting

It didn't take me long to find out that Github is serving the local public/ folder that I added to the repo. GH Pages will generate a public folder and send that to the domain.

This was a quick fix. I added public/ to my .gitignore and removed the folder from being tracked entirely using.

```
git rm -r --cached public/
```

We are back in business and the jorgesepulveda.dev is now alive!(insert any fun quote from Mary Shelley's novels). Didn't even have to wait multiple days for the DNS checks.


I hope this serves as a good tutorial for anyone who wants to bring their site from Github Pages to their domain!
