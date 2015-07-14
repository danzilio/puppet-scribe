require 'spec_helper'
require 'puppet/reportallthethings/scribe_reporter'

describe Puppet::ReportAllTheThings::ScribeReporter do
  subject { Puppet::ReportAllTheThings::ScribeReporter.new }

  it 'should load our configuration file' do
    expect(subject.config).to be_a Hash
    expect(subject.config[:category]).to eq 'puppet'
    expect(subject.config[:hosts]).to include '127.0.0.1:1463'
    subject.config.keys.each do |key|
      expect(key).to be_a Symbol
    end

    expect(subject.category).to eq 'puppet'
    expect(subject.hosts).to include '127.0.0.1:1463'
  end

  it 'should raise an error with a bad config file' do
    Puppet.settings[:confdir] = '/nonexistent'
    expect { subject.config }.to raise_error Puppet::ParseError
  end

  it 'should create a client object based on our configuration' do
    expect(subject.client).to be_a Scribe
    expect(subject.client).to respond_to(:log)
  end

  it "should warn when trying to log to a scribe server that isn't there" do
    expect(Puppet).to receive(:warning).with /No scribe servers are available/
    expect(subject.log 'data').to be nil
  end

  it "should warn when trying to log to a scribe server that isn't responding" do
    client = double
    client.expects(:log).raises(ScribeThrift::Client::TransportException)
    Scribe.expects(:new).with(
      ['127.0.0.1:1463'], 'puppet'
    ).returns client
    expect(Puppet).to receive(:warning).with /The scribe server did not respond/
    expect(subject.log 'data').to be nil
  end

  it 'should submit the report to the scribe client' do
    client = double
    client.expects(:log).returns(0)
    Scribe.expects(:new).with(
      ['127.0.0.1:1463'], 'puppet'
    ).returns client
    expect(subject.log 'data').to be 0
  end
end
