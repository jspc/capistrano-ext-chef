require 'capistrano'
module Capistrano
  module Chef
    def self.set_shell bundle
      if bundle
        'bundle exec'
      end
    end

    def self.key_string k
      if k
        "-i #{k}"
      end
    end

    def self.load_into conf
      conf.load do
        before 'deploy:setup',       'chef:bootstrap'
        before 'deploy:update_code', 'chef:provision'
        namespace :chef do
          desc 'Bootstrap chef solo'
          task :bootstrap do
            # Bootstrap node for chef and do something impressive
            # Or... at least hiding how *unimpressive* it truly is
            chef_dir  = fetch(:chef_dir, '/tmp/chef')
            bootstrap = fetch(:chef_bootstrap, 'bootstrap')
            user      = fetch(:user, ENV['USER'])
            bundle    = fetch(:chef_bundle, false)
            key       = fetch(:chef_key, nil)

            if bundle
              run_locally "cd #{chef_dir} && bundle install"
            end
            fetch(:chef_hosts, []).each do |h|
              # Because capistrano is a bit bad at outputting fron run_locally() we use system. This makes me sad
              system "cd #{chef_dir} && #{Chef.set_shell(bundle)} knife bootstrap -x #{user} #{Chef.key_string(key)} -d #{bootstrap} #{h}"
            end
            chef.provision
          end
          
          desc 'Provision out a chef node'
          task :provision do
            # Provision and configure out chef nodes
            chef_dir  = fetch(:chef_dir, '/tmp/chef')
            env       = fetch(:environment, 'production')
            user      = fetch(:user, ENV['USER'])
            bundle    = fetch(:chef_bundle, false)
            key       = fetch(:chef_key, nil)
            
            fetch(:chef_hosts, []).each do |h|
              system "cd #{chef_dir} && #{Chef.set_shell(bundle)} knife solo cook #{user}@#{h} #{Chef.key_string(key)}"
            end
          end # chef:provision
        end # chef
      end # conf.load
    end # Capistrano::Chef.load_into
  end
end

if Capistrano::Configuration.instance
  Capistrano::Chef.load_into(Capistrano::Configuration.instance)
end
