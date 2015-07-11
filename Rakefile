require 'rake'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppet-lint/tasks/puppet-lint'
require 'rspec/core/rake_task'

# These two gems aren't always present, for instance
# on Travis with --without development
begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError
end

exclude_paths = [
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*",
]

Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = exclude_paths
  config.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"
  config.disable_checks = [
    '80chars',
    'class_parameter_defaults',
    'class_inherits_from_params_class'
  ]
end

PuppetLint.configuration.relative = true
PuppetSyntax.exclude_paths = exclude_paths

RSpec::Core::RakeTask.new(:rspec) do |t|
  t.pattern = 'spec/lib/**/*_spec.rb'
end

task :test => [
  :syntax,
  :lint,
  :spec_prep,
  :rspec,
  :spec_standalone,
  :spec_clean,
]

desc "Run metadata-json-lint"
task :metadata do
  out = %x{bundle exec metadata-json-lint metadata.json}
  $? != 0 ? (raise out) : (puts "Metadata OK!")
end
