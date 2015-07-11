source ENV['RUBYGEMS_SOURCE'] || 'https://rubygems.org'

group :test do
  gem 'rake'
  gem 'puppet', ENV['PUPPET_VERSION'] || '~> 3.8'
  # https://github.com/rspec/rspec-core/issues/1864
  gem 'rspec'
  gem 'puppet-lint'
  gem 'rspec-puppet'
  gem 'puppet-syntax'
  gem 'puppetlabs_spec_helper'
  gem 'rspec-core', '3.1.7'
  gem 'metadata-json-lint'
  gem 'scribe'
  gem 'mocha'
end

group :development do
  gem 'yard'
  gem 'travis'
  gem 'travis-lint'
  gem 'puppet-blacksmith'
  gem 'guard-rake'
  gem 'pry'
end
