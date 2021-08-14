# Remdev on Azure

Spawns a remote desktop environment in the cloud in one go. 
The setup takes approximately 10 minutes before your *remdev* is ready to use. 

## How to start

You need  an Azure account and have the azure cli installed.

To start the remote desktop environment run:

````bash
$ ./start.sh
````

Once the script is finished it will print the IP address of the spawned server. You should be able to connect to it via ssh right away, as the azure cli automatically adds your ssh key.

But it will take a couple more minutes and reboots for everything to install. You can follow the process in this log

```bash
$ tail -f /var/log/cloud-init-output.log
```

After it is finished you can use the [X2Go Client](https://wiki.x2go.org/doku.php/download:start) to connect to it.

To stop it again run:

```bash
$ ./stop.sh
```

## Use for mob programming

Once you are connected you can for example start Anydesk on the remdev to allow more people join your session. Another possibility would be to use X2Go Desktop Sharing to have other people join your session.

In the bottom panel find the *Mob Timer* for facilitation.

## Installed Software

Based on Ubuntu Server 20.04 LTS

- xubuntu-core (Lightweight, minimal xfce4)
- Docker

### Python

- Python 2
- Python 3.8
- pip

### Java

- sdkman
- AdoptOpenJDK 11 (sdkman default)
- Maven
- Gradle

### JavaScript

- nvm
- latest node+npm
- yarn

### Development Tools

- git
- lazygit
- IntelliJ Ultimate
- VS Code
- Vim
- Typora
- Meld
- Mob Timer

### Browsers

- Firefox
- Google Chrome

### Remote Desktop Servers

- X2Go
- Anydesk

## Motivation

The goal is to take away the impediments of setting up a development environment.