require 'spec_helper'
require 'puppet/reportallthethings/scribe_reporter'

describe Puppet::ReportAllTheThings::ScribeReporter do
  subject { Puppet::ReportAllTheThings::ScribeReporter.new }
  before { Puppet.settings[:config] = File.join(@fixture_path, 'puppet.conf') }

  it 'should load our configuration file' do
    expect(subject.config).to be_a Hash
    expect(subject.config[:prefix]).to eq 'puppet'
    expect(subject.config[:hosts]).to include 'localhost:1463'
    subject.config.keys.each do |key|
      expect(key).to be_a Symbol
    end

    expect(subject.prefix).to eq 'puppet'
    expect(subject.hosts).to include 'localhost:1463'
  end

  it 'should create a client object based on our configuration' do
    expect(subject.client).to be_a Scribe
    expect(subject.client).to respond_to(:log)
  end

  it "should warn when trying to log to a scribe server that isn't there" do
    expect(Puppet).to receive(:warning).with /No scribe servers are available/
    expect(subject.log 'data').to be nil
  end
end
