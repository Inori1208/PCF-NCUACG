# PCF-NCUACG
A Private Cloud Framework for NCUACG club.
The project aimed to create a private cloud framework and remote data management for small group.

> [!NOTE]
> This project is considered as an experimental framework for NCUACG's property management. The security of this project might not be adequate in practical use or outdated. Please contact me if you need help about this project.

## Requirements

- Raspberry Pi
- SD card
- A Disk or USB device

## Architecture

### Platform

We aim to compose a docker running NextCloud on Raspberry Pi for basic cloud architecture.
The platform should acquire following component:

- Register/Login UI
- Disk file overview tab
- Workspace for Event manager
- Upload request tab for members
- Role alteration tab for administrator  

### IAM Roles

- Root
> Should not be used after the platform is created.
- Administrator
> Chairmen/Network manager of NCUACG.
- Event Manager
> Have access toward the main disk, able to read/modify/upload data and examine member's uploaded file. 
- Member
> Able to read data in the disk and request event manager to upload the file into the disk.

### Network environment

TBA

## TODOs

- [x] Successfully connect to the server and access the disk. 
- [x] Create a platform for people to upload files.
- [x] Setup authentication process and implement IAM policy.
- [ ] Let Raspberry Pi become VPN tunnel for remote control.

## Good luck

This is good luck Hoshino.

![image](https://cdn.discordapp.com/emojis/1346556552945078404.webp?size=96)