+++
title = "Silent Installs"
date = "2025-01-08T21:47:48-06:00"
tags = ["SysAdmin", "PowerShell"]
slug = "silent-installs"
+++

# Quick & easy intro to silent installs and ODT

I've been using Windows for over 15 years and even worked in IT maintaining PC's during college. This is why I use MacOS and Ubuntu. Jokes aside, Windows has come a long way in getting stuff done with the terminal. PowerShell and WSL makes for a great one-two punch in productivity. I loved it when 
{{<link href="https://chocolatey.org/">}}chocolatey{{</link>}} came out and used it immediately on my PC. Although it's made great progress, there are still times where it reminds me that it's Windows. 

## Excel 

Your favorite spreadsheet software, used in multiple industries and heavily used in Oil & Gas. When I was at site, which was same time as the [flash drive issue](./silent-installs.md), the one thing that kept us late one day was clicking a million times to download a specific version of Excel that we had purchased a license for. After navigating 365 A LOT, we got it installed. 

## Cue up the Office Deployment Tool

Microsoft has made a surprisingly good command line tool for downloading specific versions of Office applications and pick the architecture too. We need 32 bit as the PLC software is only compatible with that. {{<link href="https://www.microsoft.com/en-us/download/details.aspx?id=49117">}}ODT{{</link>}}was the key in solving my problems next time I need to install the software. 

When downloading the tool, it'll extract `setup.exe` and this will do the heavy lifting. 

It needs a configuration file to run. I created `configuration.xml` and specified that I want 2019, 32 bit Excel. There's also some fields to exclude apps or autolicense if you have licenses to grab from the domain. This does the trick for me. You can also make your own config with the 
{{<link href="https://config.office.com/deploymentsettings">}}Configurator tool.{{</link>}}


```xml
<Configuration>
  <Add OfficeClientEdition="32" Channel="PerpetualVL2019">
    <Product ID="Excel2019Volume">
      <Language ID="en-us" />
    </Product>
  </Add>
  <Display Level="None" AcceptEULA="True" />
</Configuration>
```

Once this file is created, you are ready to feed it into a script and let it go! I made this PowerShell script with some print statements for context. I also added a Pause to keep the terminal from closing. 

```PowerShell
Write-Output "Downloading Excel..."
.\setup.exe /download configuration.xml
Write-Output "Installing Excel..."
.\setup.exe /configure configuration.xml
Write-Output "Successfully installed Excel"
Pause
```

This is essentially a silent install. They are very handy for installing software without having to click through menus. Rockwell's software allows for this so I'm gonna be writing some really fun scripts to speed up some processes. I hope this intro is informative and I really hope it saves you hours of having to find Office software. 

