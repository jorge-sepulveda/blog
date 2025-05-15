+++
title = "Reading a Windows SSD into Manjaro"
date = "2025-05-15T15:33:38-05:00"
tags = ["SysAdmin", "Arch", "Windows", "Shell", "Manjaro"]
+++

# Windows, let me go!

When I installed Manjaro on my desktop, I got a new ssd and hard drive so I wouldn't have to risk wiping the original windows SSD I've had for 8 years. I thought I'd install Manjaro and once I'm up and running, I'll read in the data now that I have larger drives. Well, I faced a simple reminder that Windows isn't gonna let me leave without a fight and will attempt to hold my data hostage. Drama aside, we can't have that. 

## File Systems - Plug and can't play

When I plugged my old Windows SSD into my PC with an external case, Manjaro couldn't mount it because of an "incompatible" file system. I found this funny because even though NTFS has been out for over 30 years, it seems a design decision was made to exclude Microsoft's file system. File systems have changed over the years but they still have one goal. They define the structure of the files on your system and how they are organized. The C drive we know and love is paritined and NTFS is used to organize the files inside which include all sorts of stuff like Master File Tables and so on. I currently use ext4 on my drives, which is the most used system in Linux. One big difference between the two is that NTFS uses Access Control Lists to define user access in files and folders(you are the admin, but also, you're not), while Linux relies on classic POSIX permissions.

But enough about history, let's get some data.

## Verifying windows disk information in Manjaro


Let's inspect the drives a little further. Manjaro can "detect" my drive but can't mount it for access. The drives information are stored in `/dev/`, which is shorthand for devices attached to the local system. Let's run the following command to see info about drives.

```sh
$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda      8:0    0 931.5G  0 disk 
└─sda1   8:1    0 931.5G  0 part /
sdb      8:16   0   3.6T  0 disk 
└─sdb1   8:17   0   3.6T  0 part /mnt/harddrive
sdc      8:32   0 978.1G  0 disk 
├─sdc1   8:33   0   450M  0 part 
├─sdc2   8:34   0   100M  0 part 
├─sdc3   8:35   0    16M  0 part 
├─sdc4   8:36   0   977G  0 part 
└─sdc5   8:37   0   530M  0 part
```

`sda` is my main SSD and `sdb` is my hard drive. Now `sdc` is my windows SSD and it seems to have 5 partitions(Thanks again, Microsoft). Before proceeding, we need to get info about the main data partition. In this case, it will be the partition with the largest size so let's take a peek into `sdc4` by running:

```sh
$ sudo blkid /dev/sdc4
/dev/sdc4: BLOCK_SIZE="512" UUID="D41EA80E1EA7E826" TYPE="ntfs" PARTLABEL="Basic data partition" PARTUUID="7a373cd4-4c0f-492c-9ed2-c40b13df4e93"
```

And there it is, `ntfs`. It's nice to be certain what we're trying to fix. I would've been deeply surprised if this had FAT32 but Windows 10 don't use that...still, surprises can happen. 

## Reading NTFS drives with Manjaro

Tuxera maintains a package for safely reading NTFS drives called `ntfs-3g`. This is what will save me from having to plug in the drive and booting back into windows. 

```sh
$ sudo pacman -S ntfs-3g
```

We now have ntfs supported in userspace. Technically ntfs3 is supported in the kernel but I didn't wanna go messing with the way I read devices to make it happen when a package can take care of this for me. Now it's easy as creating the mount point and mounting. 

```sh
$ sudo mkdir /mnt/windowsdrive/
$ sudo mount -t ntfs-3g /dev/sdc4 /mnt/windowsdrive
```

And I now have access to my windows files, saving myself a lot of headaches. Once I'm done looking at files, I can unmount the drive for safe removal. Doing this in Dolphin works too, you'll just need your admin password since it was mounted from the shell.


```sh
$ sudo umount /mnt/windowsdrive
```

This was quite the battle to get it going but we have done it, I'm now closer to having an extra ssd in my kit once I wipe it. 
