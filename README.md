Vagrant WordPress Box
=====================

> ### This vagrant box is a fork of [`scotch-io/scotch-box`](https://github.com/scotch-io/scotch-box) and I highly recommend to read the [README](https://github.com/scotch-io/scotch-box/blob/master/README.md) to know more about the basis of this box.


## Get Started

* Download and Install [Vagrant](https://www.vagrantup.com/downloads.html)
* Download and Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* Clone the Scotch Box [GitHub Repository](https://github.com/obstschale/vagrant-wordpress-box)
* Run ``` vagrant up ```
* Access Your Project at  [http://samplecast.local/](http://samplecast.local/)

## Changes to Scotch Box

### Hostupdater & Hostmanager

This box uses 2 vagrant plugins: [`vagrant-hostsupdater`](https://github.com/cogitatio/vagrant-hostsupdater) and [`vagrant-hostmanager`](https://github.com/devopsgroup-io/vagrant-hostmanager). Make sure both are installed.

```bash
$ vagrant plugin install vagrant-hostmanager && vagrant plugin install vagrant-hostsupdater
``` 

### WordPress Instances

You can run multiple WordPress instances with this box. Each WP instance has its own git repo, MySQL DB, and Domains for easy access. Two provision scripts help you creating new WP sites. To create a new site simply add a new domain to `config/hosts.list`.

```bash
$ echo 'new-wp-site.local` >> config/hosts.list`
```

You can also add aliases using a pipe, which will be added to your local `hosts` file.

**Important: Before and after the pipe character is a space!**

```bash
$ echo 'new-wp-site.local | aliasdomain1.local | aliasdomain2.local` >> config/hosts.list`
```

One WP Instance is one line in `config/hosts.list`. The hostsupdater and hostmanager plugins will take each domain in this file and adds it to your local `hosts` file. The provision script will create a new directory in you root folder for each Domain (except aliases).

In this new folder, e.g. `new-wp-site.local/`, the WordPress template [`obstschale/wordpress-project-template`](https://github.com/obstschale/wordpress-project-template) is cloned and a new git repository is initialized and the script also installs all needed dependencies using `composer`. The second provision script creates a new database and a `local-config.php` file is created.

The new site is available and ready to use via the domains in `config/hosts.list`.

If you edit `config/hosts.list` the provisioning process needs to be started. You can simple run one of the following commands to trigger it.

```bash
$ vagrant provision # if vagrant is running
$ vagrant up --provision # if vagrant is not running
```


***

## Basic Vagrant Commands


### Start or resume your server
```bash
vagrant up
```

### Pause your server
```bash
vagrant suspend
```

### Delete your server
```bash
vagrant destroy
```

### SSH into your server
```bash
vagrant ssh
```



## Database Access

### MySQL 

- Hostname: localhost or 127.0.0.1
- Username: root
- Password: root
- Database: scotchbox

### PostgreSQL

- Hostname: localhost or 127.0.0.1
- Username: root
- Password: root
- Database: scotchbox
- Port: 5432


### MongoDB

- Hostname: localhost
- Database: scotchbox
- Port: 27017


## SSH Access

- Hostname: 127.0.0.1:2222
- Username: vagrant
- Password: vagrant

## Mailcatcher

Just do:

```
vagrant ssh
mailcatcher --http-ip=0.0.0.0
```

Then visit:

```
http://192.168.33.10:1080
```


## Updating the Box

Although not necessary, if you want to check for updates, just type:

```bash
vagrant box outdated
```

It will tell you if you are running the latest version or not, of the box. If it says you aren't, simply run:

```bash
vagrant box update
```


## Setting a Hostname

If you're like me, you prefer to develop at a domain name versus an IP address. If you want to get rid of the some-what ugly IP address, just add a record like the following example to your computer's host file.

```bash
192.168.33.10 whatever-i-want.local
```

Or if you want "www" to work as well, do:

```bash
192.168.33.10 whatever-i-want.local www.whatever-i-want.local
```

Technically you could also use a Vagrant Plugin like [Vagrant Hostmanager][15] to automatically update your host file when you run Vagrant Up. However, the purpose of Scotch Box is to have as little dependencies as possible so that it's always working when you run "vagrant up".


## Configuration

You may want to change some of the out-of-the-box configurations for
the various parts that come with Scotch Box.  To do so, `vagrant ssh`
into the box, and edit the appropriate file.  For example, to change
PHP settings:

    vagrant ssh
    sudo vim /etc/php5/apache2/conf.d/user.ini

Note that the changes that you make will be for the current running
Scotch Box only.  If you `vagrant destroy` and then `vagrant up` your
box again, these manual configuration changes will be lost.

If you prefer to automate your configuration changes so that you can
destroy and re-create boxes as needed, Vagrant allows you to create a
"provision script" that runs as part of `vagrant up`.  See the
[Vagrant
documentation](https://docs.vagrantup.com/v2/getting-started/provisioning.html)
for notes.  For example, you could add the following line to your
Vagrantfile under the `config.vm.hostname = "scotchbox"` line:

    config.vm.provision :shell, path: "bootstrap.sh"

and then create `bootstrap.sh` with the following content in the same
directory as the Vagrantfile:

    #!/bin/bash
    # Disable Zend OPcache
    sed -i 's/;opcache.enable=0/opcache.enable=0/g' /etc/php5/apache2/php.ini

This script will be run each time you `vagrant up`, and it can be run
on an already-up box using `vagrant provision`.