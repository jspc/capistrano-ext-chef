$:.push File.expand_path("../lib", __FILE__)

require 'capistrano/ext/chef/version'

Gem::Specification.new do |spec|
  spec.name = 'capistrano-ext-chef'
  spec.version = Capistrano::Ext::Chef::Version::STRING
  spec.platform = Gem::Platform::RUBY
  spec.authors = ['Funding Circle']
  spec.email = ['james.condron@fundingcircle.co.uk']
  spec.summary = 'Do something unsucky with Chef solo and capistrano'
  spec.description = 'Capistrano extension to run chef solo stuffs'
  spec.license = 'Simplified BSD'

  spec.add_dependency 'capistrano', '>=2.0.0'
  spec.add_dependency 'capistrano-ext'
  spec.add_dependency 'knife-solo'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'capistrano-spec'

  spec.require_path = 'lib'
end
