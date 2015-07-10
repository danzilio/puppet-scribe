require 'puppet'

Dir[File.expand_path(File.join(__FILE__, '..', 'fixtures', 'modules', '*', 'lib'))].each do |lib|
  $LOAD_PATH.unshift lib
end

RSpec.configure do |c|
  c.before(:all) { @fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures')) }
  c.color = true
  c.formatter = 'documentation'
end
