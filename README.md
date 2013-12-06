capistrano/ext/chef
==

Chef provisioning via capistrano

Usage
--

```ruby
require 'capistrano/ext/chef'

set :chef_dir, FILE.join( File.dirname(__FILE__), 'conifg', 'chef' )
set :chef_bootstrap, 'my_bootstrap_script'
set :chef_hosts, [host1.example.com, host2.example.com]
```

Tasks
--

  * `chef:bootstrap` hooks in before `deploy:setup` and calls `deploy:provision`
  * `chef:provision` hooks in before `deploy:update_code`
