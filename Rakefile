require 'rake'
require 'puppetlabs_spec_helper/rake_tasks'
require 'rspec/core/rake_task'

# These two gems aren't always present, for instance
# on Travis with --without development
begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError
end

Rake::Task[:spec].clear

RSpec::Core::RakeTask.new(:rspec) do |t|
  t.pattern = 'spec/lib/**/*_spec.rb'
end

task :spec => [
  :spec_prep,
  :rspec,
  :spec_clean
]

desc "Run metadata-json-lint"
task :metadata do
  out = %x{bundle exec metadata-json-lint metadata.json}
  $? != 0 ? (raise out) : (puts "Metadata OK!")
end
