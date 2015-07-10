require 'rubygems'
require 'scribe'
require 'json'
require 'yaml'
require 'puppet'
require 'puppet/reportallthethings/helper'

module Puppet
  module ReportAllTheThings
    class ScribeReporter
      include Puppet::Util::MethodHelper

      def log(data)
        begin
          client.log data.strip
        rescue ScribeThrift::Client::TransportException
          Puppet.warning 'The scribe server did not respond.'
        rescue ThriftClient::NoServersAvailable
          Puppet.warning 'No scribe servers are available.'
        end
      end

      def client
        @client ||= Scribe.new hosts, prefix
      end

      def prefix
        config[:prefix]
      end

      def hosts
        config[:hosts]
      end

      def config
        return @config if @config
        configfile = File.join([File.dirname(Puppet.settings[:config]), "scribe.yaml"])
        raise(Puppet::ParseError, "Scribe report config file #{configfile} not readable") unless File.exist?(configfile)
        @config = symbolize_options(YAML.load_file(configfile))
      end
    end
  end
end
