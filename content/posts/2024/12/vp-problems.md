+++
title = "Having fun with Rockwell's VantagePoint"
date = "2024-12-22T11:26:38-06:00"
#dateFormat = "2006-01-02" # This value can be configured for per-post date formatting
tags = ["SysAdmin", "Rockwell"]
slug = "vp-problems"
+++

# Rockwell does it again

I’m currently setting up reporting using VantagePoint. It was supposed to be a smooth process but computers always seem to find new ways to prevent that. 

I had called the support line to notify them that Modelbuilder, a tool used for modeling reports was not working properly. 

## My first "anomaly"
After they digged into it further with their own virtual machines, I had found an “anomaly” as Rockwell calls it. You can’t fool me, guys. A bug is a bug. 

Modelbuilder has an issue with VantagePoint 8.4.1 where it won’t appear in the sources tab.  The software is installed in control panel but VantagePoint won’t find it. 

## Other routes

I thought of workarounds to this and that included downgrading to 8.4.0, which Rockwell had informed me was supported. 

It was not possible due to Microsoft SQL. We have 2022 installed on the VM and 8.4.0 could only support 19. The choices here was to wait for Modelbuilder to be updated or downgrade everything to install SQL 2019. That would include EVERYTHING. HMI, Historians, Report Server, the whole 9 yards. Out of risking breaking everything, I had decided to wait. 

Fortunately, Rockwell had *presumably* updated modelbuilder to support the latest version of VantagePoint. Getting a bug fixed in 3 days is rather impressive but I have to see it with my own eyes when I'm installing it.  

I’ll share the tech note where they updated the latest software and the same technote for reporting in case you happen to run into this. 

{{<link href="https://rockwellautomation.custhelp.com/app/answers/answer_view/a_id/66232/track/AvOVZgo2Dv8W~XOjGtcK~yI_b6EqGy75Mv9n~zj~PP_u">}}Updated Modelbuilder Software, you'll need access to the technotes.{{</link>}}
