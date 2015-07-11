require 'puppet'
require 'mocha/test_unit'

def fixture_path
  File.expand_path(File.join(__FILE__, '..', 'fixtures'))
end

Dir[File.expand_path(File.join(fixture_path, 'modules', '*', 'lib'))].each do |lib|
  $LOAD_PATH.unshift lib
end

RSpec.configure do |c|
  c.before(:each) do
    Puppet.settings[:confdir] = File.join(fixture_path, 'puppet')
  end

  c.color = true
  c.formatter = 'documentation'

  if ENV['PUPPET_DEBUG']
    Puppet::Util::Log.level = :debug
    Puppet::Util::Log.newdestination(:console)
  end
end
