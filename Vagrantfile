Vagrant.configure(2) do |config|

  #
  # Get latest debian, on WIN remember to set virtualisation support (VT-x)
  # in BIOS at Advanced > CPU > Intel Virtualisation Support > Activated
  # https://www.thomas-krenn.com/de/wiki/Virtualisierungsfunktion_Intel_VT-x_aktivieren
  #
  config.vm.box = "dhoppe/debian-8.2.0-amd64"
  config.vm.box_url = "https://atlas.hashicorp.com/dhoppe/boxes/debian-8.2.0-amd64"

  #
  # Simple networking: Only port forwarding
  #
  config.vm.network :forwarded_port, guest: 80, host: 4567
  config.vm.network :private_network, ip: "192.168.56.150"

  #
  # Shared folder
  #
  config.vm.synced_folder "./www", "/var/www/html"

  #
  # Provision using puppet
  #
  config.vm.provision :puppet do |puppet|
    puppet.environment_path = "environments"
    puppet.environment = "development"

    #
    # Only for building the stack
    #
    # puppet.options = '--verbose --debug'
    puppet.options = '--verbose'

  end

end