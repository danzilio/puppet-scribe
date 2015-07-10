require 'puppet'
require 'puppet/reportallthethings/scribe_reporter'

Puppet::Reports.register_report(:scribe) do
  def process
    scribe = ScribeReporter.new
    scribe.log(JSON.pretty_generate(self.to_h))
  end
end
