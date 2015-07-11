require 'spec_helper'
require 'puppet/reports/scribe'

processor = Puppet::Reports.report(:scribe)

describe processor do
  let(:client) { double }
  subject { Puppet::Transaction::Report.new('apply').extend(processor) }

  it 'should submit the report to scribe' do
    client.expects(:log).returns(0)

    Scribe.expects(:new).with(
      ['127.0.0.1:1463'], 'puppet'
    ).returns client

    subject.process
  end
end
