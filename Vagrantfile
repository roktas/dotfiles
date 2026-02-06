Vagrant.configure("2") do |config|
  config.vm.box = "roktas/debian"

  config.vm.provision "shell", privileged: false, inline: <<~EOF
    bash /vagrant/deinstall.sh
    bash /vagrant/install.sh
  EOF
end
