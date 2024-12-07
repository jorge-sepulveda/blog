+++
title = "NTFS saves the day"
date = 2024-12-07
draft = false
+++

# Gotta love flash drive formatting

Earlier at site this week, we found that it is faster to put files in a USB stick and DRIVE over to the computer where we need the files.

The network connection is reliable but transferring files over the network can take time, especially if we are taking it from Virtual Machines.

I have a kit of 7 flash drives and some USB C adapters for any newer devices.

Then a serious situation came down.

My colleague needed to move a file from a PC on the network to his laptop, I lent him my kit and he drove off.

15 minutes later he calls me saying that none of the flash drives are working. It was a 5GB file.

The exxagerated conversation followed:

- "This is what you are gonna do, you are gonna grab the green drive and format it to NTFS."

- "I don't know want to delete your files."

- "Don't worry about the files! We need this data!"(I knew there was no data on the green drive)

- "The file is now transferring."

Crisis averted. We got the files in the drive and NTFS saved the day for having to wait eons for files to transfer on the network

## FAT32 vs. NTFS

FAT32 is an older file system format, popularly used by flash drives and almost every device can read that format.

The pickle here is that since it's 32 bit, you cannot transfer files larger than 4 GB. That's usually not a problem until you need a monster installer file.

NTFS resolves that, not being limited to 32 bit or 64 bit systems, it can scale up and transfer any size files. 

Next time you need huge data files transferred on your drives, NTFS might save you as it did us. 




