# Simple LAMP devstack for Vagrant

_vagrant-devstack_ is a simple and lightweight LAMP devstack provisioning a Debian 8.2 (64-bit), a LAMP environment and the latest nodejs module (using s workaround).

## Prerequisites

* Install [Vagrant](https://www.vagrantup.com/downloads.html) and [VirtualBox](https://www.virtualbox.org/)
* Ensure [support for 64-bit virtualisation (BIOS setting)](https://www.thomas-krenn.com/de/wiki/Virtualisierungsfunktion_Intel_VT-x_aktivieren)

## Start engine

To initialise the system, simply clone this repo, cd into it and run `vagrant up`. Get a coffee - it will take some time on the first run.

## Configuration

After the first install run you will need to configure your host system and the PHP stack.

### Making dev.loc available from your host

Please edit your local _hosts_ file. You will need administrator privileges for this. Append the following line to your host file:

    # File location:
    # Mac: /private/etc/hosts
    # WIN: C:\Windows\System32\drivers\etc\hosts
    192.168.56.150 dev.loc

### Update php.ini on your development system

Please update your box' php config with `date.timezone = Europe/Berlin` in

    /etc/php5/apache2/php.ini
    /etc/php5/cli/php.ini

**Have fun!**
