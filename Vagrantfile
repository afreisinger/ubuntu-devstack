# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

# Measuring time taken for 'vagrant up'
# If you want to exclude time for importing the box, setting up network interfaces, port forwards, shared folders mounting etc then measure only time that is needed for provisioning:
# Bring the box up (without provisioning)
# time vagrant up --no-provision
# Measure provisioning time
# time vagrant provision

BEGIN{
  START_TIME = Time.new
  puts "Start Time : #{START_TIME}"
}
END{
  END_TIME = Time.new
  interval = END_TIME - START_TIME
  puts "  Started at #{START_TIME} and ended at #{END_TIME}."
  puts "  Total time taken:  #{(interval/60).round(2)} minutes."
  puts "  Completed successfully!"
}


# Require plug-ins
# vagrant plugin install vagrant-disksize
# vagrant plugin install vagrant-timezone
# vagrant plugin install vagrant-hostmanager
# vagrant plugin install vagrant-vbguest

required_plugins = %w( vagrant-hostmanager vagrant-vbguest vagrant-timezone vagrant-disksize)
required_plugins.each do |plugin|
  system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

# Require YAML module
require 'yaml'


# Specify minimum Vagrant version and Vagrant API version
Vagrant.require_version '>= 2.2.9'
VAGRANTFILE_API_VERSION = "2"


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

   
  # Read YAML file with box details
  _conf = YAML.load(File.open(File.join(File.dirname(__FILE__), 'configuration.yml'),File::RDONLY).read)

  # forcing config variables
  _conf["vagrant_dir"] = "/vagrant"

    
 
  config.vm.define _conf['hostname'] do |v| end

  config.vm.box = ENV['box'] || _conf['box']
  config.vm.box_version = _conf['version']
  
 

  config.ssh.insert_key = true
  config.ssh.forward_agent = true

  config.vm.box_check_update = true

  config.vm.hostname = _conf['hostname']
 #config.vm.network :private_network, ip: _conf['ip']
  config.vm.network "public_network", bridge: "en1: Wi-Fi (AirPort)",ip: _conf['ip'], nic_type: "virtio"
 # config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)", ip: "192.168.1.123", nic_type: "virtio", name: "vboxnet2"
 # (0..0).each do |i|
 # config.vm.disk :disk, size: _conf['disksize'], name: "disk-#{i}", primary: true
 # end
  
  #vagrantconfig.vm.synced_folder _conf['synced_folder'], _conf['document_root'], :create => "true", :owner => _conf['www_user'], :group => _conf['www_group']
      
  
  if File.exists?(File.join(File.dirname(__FILE__), 'provision/provision-pre.sh')) then
    config.vm.provision :shell do |shell|
      shell.path = File.join( File.dirname(__FILE__), 'provision/provision-pre.sh' )
     #shell.env = {'t3bs_typo3_version' => _conf['typo3_version']}
    end
  end

  if Vagrant.has_plugin?('vagrant-timezone')
    config.timezone.value = "America/Argentina/Buenos_Aires"
  end
    
  if Vagrant.has_plugin?('vagrant-hostmanager')
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = true
  end

  if Vagrant.has_plugin?('vagrant-vbguest')
    config.vbguest.auto_update = _conf['vbguest_auto_update']
  end

  if Vagrant.has_plugin?('vagrant-disksize')
    config.disksize.size = _conf['disksize']
    #config.vm.provision "shell", path: "provision/disk-extend.sh"
    # Run a script on provisioning the box to format the file system
    #if File.exists?(File.join(File.dirname(__FILE__), 'provision/disk-extend.sh')) then
      #config.vm.provision :shell do |shell|
      #shell.path = File.join( File.dirname(__FILE__), 'provision/disk-extend.sh' )
      #end
    #end
  end

  
  config.vm.provider :virtualbox do |vb|
    
    vb.linked_clone = _conf['linked_clone']
    vb.name = _conf['hostname']
    vb.memory = _conf['memory'].to_i
    vb.default_nic_type = "virtio"
    
    vb.cpus = _conf['cpus'].to_i
      if 1 < _conf['cpus'].to_i
        vb.customize ['modifyvm', :id, '--ioapic', 'on']
      end
    vb.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
    #vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
    #vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    #vb.customize ['modifyvm', :id, '--natnet1', '192.168.1.0/24']
   
    #vb.customize ['modifyvm', :id, '--nic1', 'nat']
    #vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
    #vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
   
    #vb.customize ['modifyvm', :id, '--nic2', 'hostonly', '--hostonlyadapter2', 'vboxnet0']
    #vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
    #vb.customize ["modifyvm", :id, "--cableconnected2", "on"]
   
    vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]

    #vb.customize ['modifyvm', :id, '--nic3', 'hostonly', '--hostonlyadapter3', 'vboxnet1']
    vb.customize ["modifyvm", :id, "--audio", 'none']   
    vb.customize ['modifyvm', :id, '--uartmode1', 'disconnected']
    vb.customize ["modifyvm", :id, "--usbehci", 'off']
 
  end

 go = true
  if go then
  config.vm.provision "ansible_local" do |ansible|
   ansible.extra_vars = {
     t3bs: _conf
    }
    ansible.playbook = "provision/playbook.yml"
    ansible.version = "2.9.6"
    ansible.verbose = false
    ansible.become = true
  end
end

  if File.exists?(File.join(File.dirname(__FILE__), 'provision/provision-post.sh')) then
   config.vm.provision :shell do |shell|
      shell.path = File.join( File.dirname(__FILE__), 'provision/provision-post.sh' )
      shell.env = {
        't3bs_typo3_version' => _conf['typo3_version'],
        't3bs_hostname' => _conf['hostname'],
        't3bs_ip' => _conf['ip'],
        't3bs_use_tls' => _conf['use_tls'],
        
      }
    end
  end
end
