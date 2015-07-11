require 'spec_helper'
require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.confdir = File.join(fixture_path, 'puppet')
end

describe 'scribe_reporter' do
  let(:confdir) { File.join(fixture_path, 'puppet') }
  let(:scribeconf) { File.join(confdir, 'scribe.yaml') }
  let(:params) {{ :hosts => '127.0.0.1:1463' }}

  context 'with defaults' do
    it { is_expected.to contain_file(scribeconf).with_content /hosts:\s+-\s+"127.0.0.1:1463"/ }
    it { is_expected.to contain_file(scribeconf).with_content /category:\s+puppet/ }
    it { is_expected.to contain_package('scribe').that_comes_before("File[#{scribeconf}]") }
    it { is_expected.to contain_file(confdir).with_ensure('directory') }
    it { is_expected.to contain_ini_subsetting('puppet.conf/reports/scribe').with_section('master') }
  end

  context 'when not managing $confdir' do
    let(:params) {{ :hosts => '127.0.0.1:1463', :manage_confdir => false }}
    it { is_expected.not_to contain_file(confdir) }
  end

  context 'when not managing the scribe gem' do
    let(:params) {{ :hosts => '127.0.0.1:1463', :manage_package => false }}
    it { is_expected.not_to contain_package('scribe') }
  end

  context 'when running in masterless mode' do
    let(:params) {{ :hosts => '127.0.0.1:1463', :masterless => true }}
    it { is_expected.to contain_ini_subsetting('puppet.conf/reports/scribe').that_requires("File[#{scribeconf}]") }
    it { is_expected.to contain_ini_subsetting('puppet.conf/reports/scribe').with_section('main') }
    it { is_expected.to contain_ini_subsetting('puppet.conf/reports/scribe').with_path(File.join(confdir, 'puppet.conf')) }
  end

  context 'when passing a nonstandard $confdir' do
    let(:params) {{ :hosts => '127.0.0.1:1463', :confdir => '/some/path' }}
    it { is_expected.to contain_file('/some/path/scribe.yaml') }
    it { is_expected.to contain_ini_subsetting('puppet.conf/reports/scribe').with_path('/some/path/puppet.conf') }
  end
end
