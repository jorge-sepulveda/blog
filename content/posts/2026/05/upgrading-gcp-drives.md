+++
title = "Upgrading drives in GCP the good ol' fashioned way"
date = "2026-05-12T22:10:43-05:00"
slug = "upgrade-gcp-drive"
tags = ["GCP", "PowerShell", "SysAdmin"]
keywords = ["", ""]
draft=true
readingTime = true
+++

## It's drivin' me crazy

It has been fun running systems across three different cloud environments. 
Each one has it's own nuance making me learn one thing three different times. 
The most recent fun has been managing disks for Virtual Machines. 

I needed to upgrade some of our servers' hard drives to solid state drives to fix some disk bottlenecks. 
AWS was by far the cleanest, gold star. You don't even need to turn off the VM, they'll upgrade it for you live, no downtime. 
Azure ranks second place here, I only need to turn off the VM to upgrade the disk in place. No big deal.

Google is the worst offender here. 
You need to turn off the VM, clone the disks to a new upgraded drive and then swap the drives by detaching the old drive and attach the new drive with the same settings. 
Come on Google, AWS figured out how to swap parts while driving the car, Azure needs a pit stop, but this.. your design choice was to make me stop and reassemble it? 

Nuance aside, this felt the most nostalgic. Back in my first IT job I would pull a machine, clone the hard drive using those two bay drive docks and then replace the drive to complete the upgrade. That's right, my first IT job didn't even have SCCM, we we're barely lucky enough to get a drive bay. 

Nostalgia aside, being pulled back in time to manage infrastructure isn't a great feeling in itself. 

## The plan

Rant over, let's test this.
**I need to turn off the virtual machine, clone the existing drive as an ssd, swap the drives and then turn the VM back on.**
We'll be using the GCP Powershell module but you also have the option to use the cloud shell module in case you want to run this in the browser.

Once it's downloaded, authenticate and talk to your project via `gcloud init` and we are good to go.

For this exercise, I've created a dummy Windows Server with an extra D drive and I'll swap it for an ssd drive since this is what I need to do on the production server. I'm expecting the new drive to just swap in without configuration and to make doubly sure, this ISO of Ubuntu should be on the new disk upon rebooting.

{{<image src="/img/2026/05/upgrade-gcp-drives/0.5.png" width="700px" position="center">}}


{{<image src="/img/2026/05/upgrade-gcp-drives/0.6.png" width="700px" position="center">}}

I'll add the screenshots for what its supposed to look like in the console as we go along. 

### 1. Stop the Virtual Machine

First things first, put the VM to bed.

```powershell
gcloud compute instances stop 'jorge-testing' --zone=us-south1-c
Stopping instance(s) jorge-testing...done.
```


{{<image src="/img/2026/05/upgrade-gcp-drives/1.png" width="700px" position="center">}}
### 2. Take a snapshot

snapshot, snapshot, snapshot! Even though I need one to make the disk, you should schedule them.
This can vary in time depending how big the disk is. 


```powershell
gcloud compute disks snapshot 'temporary-d' --snapshot-names='testing-before-prod' --zone=us-south1-c
Creating snapshot(s) testing-before-prod...done.
```

{{<image src="/img/2026/05/upgrade-gcp-drives/2.png" width="700px" position="center">}}
### 3. Clone the drive 

Using that snapshot we'll create a new drive as an ssd. 
This is another one if those "grab a coffee moments." Make note of that "in use by" too. My VM is still pointing at `temporary-d`
```powershell
gcloud compute disks create 'temporary-d-ssd' `
  --source-snapshot='testing-before-prod' `
  --type=pd-ssd `
  --zone=us-south1-c `
  --size=10
NAME             ZONE         SIZE_GB  TYPE    STATUS
temporary-d-ssd  us-south1-c  10       pd-ssd  READY
```


{{<image src="/img/2026/05/upgrade-gcp-drives/3.png" width="700px" position="center">}}
### 4. Detach the old drive from the Virtual Machine

Ok, we have a snapshot for rollbacks, and we have our spanking new clone of a disk as an SSD. Let's begin surgery by detaching the old disk. In the console you should see no drives. 

```powershell
gcloud compute instances detach-disk 'jorge-testing' `
  --disk='temporary-d' `
  --zone=us-south1-c
```

{{<image src="/img/2026/05/upgrade-gcp-drives/4.png" width="700px" position="center">}}
### 5. Attach the new drive

aaaaand now we'll attach the new drive.
This is a big part. There is a field called the `device-name` which is id used to identifying these persistent disks. 
In order for Windows to see the "same device" we need to make sure that the `device-name` of the new disk we are attaching has the same name as the old one. 
When I set up the server, I named it `the-temp-d` but you can also run `gcloud compute instances describe` to get the same info. 
This is also handy when you have a handful of disks attached. 

```powershell
gcloud compute instances attach-disk 'jorge-testing' `
  --disk='temporary-d-ssd' `
  --device-name='the-temp-d' `
  --zone=us-south1-c 
```

{{<image src="/img/2026/05/upgrade-gcp-drives/5.png" width="700px" position="center">}}
### 6. Restart the VM

Start the VM and try to either SSH or RDP into the server and bam! We have successfully replaced the boot disk. 

```powershell
gcloud compute instances start jorge-testing --zone=us-south1-c
Starting instance(s) jorge-testing...done.
```

Look at the VM one more time and there's our image! We have swapped out the drive for the SSD all quietly and such. 


At first it felt a little like open heart surgery, but a couple of runs and you feel comfy with it. Now if something goes horribly wrong doing this in production...well, I guess the fix would be in another post, huh?

Until next time!

