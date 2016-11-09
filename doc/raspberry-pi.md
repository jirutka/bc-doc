# BigClown Alpha - Software Setup for Raspberry Pi Host Platform

## Prerequisites

- BigClown products (Bridge Module, sensors, actuators, ...)
- Raspberry Pi 3
- Power adapter with USB Micro-B plug (power for Raspberry Pi)
- USB cable type A to Micro-B (between Bridge Module and Raspberry Pi)
- MicroSD card (at least 4GB) - [make sure the card is compatible](
  http://elinux.org/RPi_SD_cards)
- MicroSD card reader
- Ethernet (LAN) cable
- LAN with DHCP server and internet connectivity
- Desktop environment (Windows, OS X, Linux)
- Administrator privileges (to write on the MicroSD card)

## Prepare MicroSD card for Raspberry Pi

Download HypriotOS image
[hypriotos-rpi-v1.0.0-hub.zip]
(https://docs.google.com/a/bigclown.com/uc?id=0B5pXL_JAACMvYU9DQm8xbFFvSkU&export=download)

> Note: BigClown has changed the default hostname to "hub" in the original
> image. No other changes have been made.

#### On Windows desktop

Unzip the image (e.g. using [7-Zip](http://www.7-zip.org/))

Write `hypriotos-rpi-v1.0.0-hub.img` to MicroSD card (e.g. using
[Win32 Disk Imager]
(https://sourceforge.net/projects/win32diskimager/files/latest/download))

#### On OS X desktop

Open Terminal and navigate to your folder with downloads, for example:

`cd ~/Downloads`

Unzip the downloaded image:

`unzip hypriotos-rpi-v1.0.0-hub.zip`

Insert the MicroSD card to your Mac and find out what is the disk
identifier (it will be /dev/diskX):

`diskutil list`

You have to unmount the disk (replace X with the appropriate identifier):

`diskutil unmountDisk /dev/diskX`

Write the image to the card (replace X with the appropriate identifier):

`sudo dd if=hypriotos-rpi-v1.0.0-hub.img of=/dev/rdiskX bs=1m`

> Note: "sudo" means the process will start with administrator privileges
> and may require your account password
> (if you are eligible for administrator rights).

This will take some time. If you get a "permission denied" message,
please make sure your MicroSD card is not write-protected
(e.g. by SD card adapter).

Eject the card (replace X with the appropriate identifier):

`diskutil eject /dev/diskX`

#### On Linux desktop

Open Terminal and navigate to your folder with downloads, for example:

`cd ~/Downloads`

Unzip the downloaded image:

`unzip hypriotos-rpi-v1.0.0-hub.zip`

Insert the MicroSD card to your Linux desktop and find out what is the disk
identifier (it will be /dev/sdX):

`lsblk`

You have to unmount all disk partitions (replace X with the appropriate
identifier):

`sudo umount /dev/sdX?`

> Note: "sudo" means the process will start with administrator privileges
> and may require your account password
> (if you are eligible for administrator rights).

Write the image to the card (replace X with the appropriate identifier):

`sudo dd if=hypriotos-rpi-v1.0.0-hub.img of=/dev/sdX bs=1M status=progress`

This will take some time. If you get a "permission denied" message,
please make sure your MicroSD card is not write-protected
(e.g. by SD card adapter).

Eject the card (replace X with the appropriate identifier):

`eject /dev/sdX`

## Boot Raspberry Pi

1. Insert the MicroSD card to Raspberry Pi
2. Plug-in the Ethernet cable to Raspberry Pi
3. Connect the USB power adapter to Raspberry Pi

## Log-in to Raspberry Pi

Next step is to login to Raspberry Pi via SSH terminal.

You can access the device in two ways:

- Using IP address (you have to determine what is the assigned
  address from the DHCP server)
- Using zeroconf mechanism by accessing "hub.local" host
  (this mechanism should work on any recent desktop)

#### On Windows desktop

1. Download [PuTTY]
   (http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html)
2. Open PuTTY and open SSH session:

Use hostname: **hub.local** or **raspberry-ip-address**

Use login: **pirate**

Use password: **hypriot**

#### On OS X & Linux desktop

Open Terminal and connect to Raspberry Pi:

`ssh pirate@hub.local` or `ssh pirate@raspberry-ip-address`

Use password: **hypriot**

## First-time setup on Raspberry Pi

Change password:

`passwd`

Create data directory for container:

`sudo mkdir /var/hub`

## Run Clown.Hub software on Raspberry Pi

BigClown uses Docker container technology for seamless software delivery.

Pull Docker image from Docker Hub and run the container in one command:

`docker run -d -p 80:80 -p 443:443 -p 1883:1883 --privileged
 -v /dev:/dev -v /var/hub:/var/hub -h hub-container --name hub
 clown/rpi-hub`

You can stop container by:

`docker stop hub`

And start it again by:

`docker start hub`

## Notes for Raspberry Pi 2

If you are using Raspberry Pi 2, it is necessary to replace Caddy webserver binary to work properly.

```sh
wget -O - https://github.com/mholt/caddy/releases/download/v0.9.1/caddy_linux_arm7.tar.gz | tar -xz caddy_linux_arm7
mv caddy_linux_arm7 /var/hub/caddy

docker exec hub cp /var/hub/caddy /usr/local/bin/caddy
```

Note: Caddy 0.9.3 has broken WebSockets proxy, we recommend to stay on 0.9.1 for now.

## Open the browser and play with the gadgets

Navigate to URL:

<https://hub.local/app> or <https://raspberry-ip-address/app>

Be aware, that self-signed autogenerated certificate is used at web server side, so you have to accept it in web browser (otherwise browser do not process content from web server over TLS).

Username: **clown**  
Password: **bigclown**  

## MQTT playground

Look at measured values (this will subscribe to messages from MQTT broker
running inside the container):

`docker exec hub mosquitto_sub -v -t 'nodes/bridge/0/#'`

Set relay to "true" state (this will publish message to MQTT broker
running inside the container):

`docker exec hub mosquitto_pub -t nodes/bridge/0/relay/i2c0-3b/set
 -m '{"state": true}'`

Set relay to "false" state:

`docker exec hub mosquitto_pub -t nodes/bridge/0/relay/i2c0-3b/set
 -m '{"state": false}'`

If you want to see values from a simulator (running as parallel process
inside the container):

`docker exec hub mosquitto_sub -v -t 'nodes/bridge/simulator/#'`