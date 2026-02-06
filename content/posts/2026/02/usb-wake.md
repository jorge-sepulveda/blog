+++
title = "Slaying the demons haunting my motherboard"
date = "2026-02-04T21:15:07-06:00"
tags = ["SysAdmin"]
slug = "usbwake"
readingTime = true
+++

# Verifying motherboard settings always pays off

During college, my gaming PC had a funny thing happening. Sometimes, it would randomly boot up. I'd be hanging out in my room when all of a sudden I hear the low hum of the fans and Windows would be waiting for me to input my credentials. I honestly just chalked it up to crappy electrical wiring in the house I lived in because it stopped happening when I lived in Phoenix. 

A couple of days ago, I was disconnecting a USB hub with peripherals and there's my old friend, turning on the lights and fans. I decided to face this demon head on and exorcise it from my pc. 

## Trusty ol' motherboard

I'm using an Asrock Z97 Extreme4...yes it's still using DDR3, yes I know it's old, and it doesn't have a TPM module either. Microslop said that I don't deserve Windows 11 and that they would forgive if me if I purchased a new PC. Now I'm using Manjaro because I DECIDE when I stop using my PC equipment. 

I booted into the settings and found the Deep Sleep settings in my BIOS, and that was the culprit all these years. Deep Sleep(also called Energy related Products Directive for you British readers) had different states for providing power to ports. This would leave all my peripherals on in case I need to charge my phone while my PC is turned off... time to fix that. 

So I enabled it in both S4 and S5 and I have defeated a longtime enemy. I unplugged the usb hub and no power, just quiet. 

In case you ever have peripherals that boot up your PC, check your advanced chipset next time, it may also help you slay your demons. 


