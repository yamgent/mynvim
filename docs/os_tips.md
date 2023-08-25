# OS Tips...

## VirtualBox with Debian Guest

### VBox Guest Additions

```sh
$ sudo apt update
$ sudo apt install build-essential dkms linux-headers-$(uname -r)

$ cd /media/cdrom/
$ sudo sh ./VBoxLinuxAdditions.run

$ sudo reboot now
```

### Shared Folder

```sh
$ sudo adduser <user> vboxsf
$ sudo reboot now  # logging off is also fine
```

## Ubuntu

### Dual Boot, Wrong Windows Time

On Ubuntu:

```sh
$ timedatectl set-local-rtc 1
```

### Show logs during bootup and shutdown

Edit `/etc/default/grub`. Change this line to remove quiet and splash:

```diff
- GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
+ GRUB_CMDLINE_LINUX_DEFAULT=""
```

Then run:

```sh
$ sudo update-grub2
```
