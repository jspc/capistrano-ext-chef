require 'capistrano'
module Capistrano
  module Chef
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
            fetch(:chef_hosts).each do |h|
              run_locally "cd #{chef_dir} && knife bootstrap -x #{user} -d #{bootstrap} #{h}"
            end
          end
          
          desc 'Provision out a chef node'
          task :provision do
            # Provision and configure out chef nodes
            chef_dir  = fetch(:chef_dir, '/tmp/chef')
            env       = fetch(:environment, 'production')
            user      = fetch(:user, ENV['USER'])
            fetch(:chef_hosts).each do |h|
              run_locally "cd #{chef_dir} && knife solo cook #{user}@#{h}"
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
