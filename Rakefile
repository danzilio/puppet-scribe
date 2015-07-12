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

namespace :strings do
  doc_dir = File.dirname(__FILE__) + '/doc'
  git_uri = `git config --get remote.origin.url`.strip
  vendor_mods = File.dirname(__FILE__) + '/.modules'

  desc "Checkout the gh-pages branch for doc generation."
  task :checkout do
    unless Dir.exist?(doc_dir)
      Dir.mkdir(doc_dir)
      Dir.chdir(doc_dir) do
        system 'git init'
        system "git remote add origin #{git_uri}"
        system 'git pull'
        system 'git checkout gh-pages'
      end
    end
  end

  desc "Generate documentation with the puppet strings command."
  task :generate do
    Dir.mkdir(vendor_mods) unless Dir.exist?(vendor_mods)
    system "bundle exec puppet module install puppetlabs/strings --modulepath #{vendor_mods}"
    system "bundle exec puppet strings --modulepath #{vendor_mods}"
  end

  desc "Push new docs to GitHub."
  task :push do
    Dir.chdir(doc_dir) do
      system 'git add .'
      system "git commit -m 'Updating docs for latest build.'"
      system 'git push origin gh-pages'
    end
  end

  desc "Run checkout, generate, and push tasks."
  task :update => [
    :checkout,
    :generate,
    :push,
  ]
end
