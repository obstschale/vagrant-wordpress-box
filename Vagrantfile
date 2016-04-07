# -*- mode: ruby -*-
# vi: set ft=ruby :

vagrant_dir = File.expand_path(File.dirname(__FILE__))

Vagrant.configure("2") do |config|

    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true

    config.vm.box = "scotch/box"
    config.vm.hostname = 'scotchbox'
    config.vm.network :private_network, ip: '192.168.99.10'
    config.vm.synced_folder ".", "/var/www", :mount_options => ["dmode=777", "fmode=666"]

    # Local Machine Hosts
    #
    # If the Vagrant plugin hostsupdater (https://github.com/cogitatio/vagrant-hostsupdater) is
    # installed, the following will automatically configure your local machine's hosts file to
    # be aware of the domains specified below. Watch the provisioning script as you may be
    # required to enter a password for Vagrant to access your hosts file.
    #
    # By default, we'll include the domains setup by VVV through the vvv-hosts file
    # located in the www/ directory.
    #
    # Other domains can be automatically added by including a vvv-hosts file containing
    # individual domains separated by whitespace in subdirectories of www/.
    if defined? VagrantPlugins::HostsUpdater

        # Capture the paths to all vvv-hosts files under the www/ directory.
        paths = []
        Dir.glob(vagrant_dir + '/config/hosts.list').each do |path|
            paths << path
        end

        # Parse through the vvv-hosts files in each of the found paths and put the hosts
        # that are found into a single array.
        hosts = []
        paths.each do |path|
            new_hosts = []
            file_hosts = IO.read(path).split( "\n" )
            file_hosts.each do |line|
                if line[0..0] != "#"
                    sameHosts = line.gsub( ' ', '' ).split( "|" )
                    if sameHosts.length > 1
                        sameHosts.each do |shost|
                            new_hosts << shost
                        end
                    else
                        new_hosts << line
                    end
                end
            end
            hosts.concat new_hosts
        end

        # Pass the final hosts array to the hostsupdate plugin so it can perform magic.
        config.hostsupdater.aliases = hosts

    end

    # set synced_folder
    config.vm.synced_folder "provision/", "/srv/provision"
    config.vm.synced_folder "config/", "/srv/config"

    config.vm.provision "shell", path: "provision/vHost.sh"
    config.vm.provision "shell", path: "provision/database.sh"

end
