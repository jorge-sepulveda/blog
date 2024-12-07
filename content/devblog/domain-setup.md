+++
title = "Registering the blog to my domain"
date = 2024-12-07
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

For now, I'll have to revert back to the default github link until I resolve this. 


