# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "bento/ubuntu-20.04"
  config.vm.provision :shell, privileged: false, :path => "scripts/setup.sh"
  config.vm.provision :shell, privileged: true, inline: "touch /etc/is_vagrant_vm"

  config.vm.provider "virtualbox" do |vb|
    # Set easy to remember VM name
    vb.name = "xdp-playground"
    # Customize the amount of memory on the VM:
    vb.memory = "2048"
    # Assign 2 cores
    vb.cpus = 2
  end

end
