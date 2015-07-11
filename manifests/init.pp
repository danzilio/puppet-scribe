# == Class: scribe_reporter
# This class manages the configuration file for the Scribe Puppet report
# processor and the scribe gem.
#
# == Parameters:
# [*hosts*]
#   Required string or array. A single string or array of multiple
#   "<host>:<port>" combinations. Strings will automatically be cast into an
#   Array.
# [*category*]
#   Optional string. The Scribe category that should be sent with the report
#   body. Defaults to puppet.
# [*manage_package*]
#   Optional boolean. If this module should manage the scribe gem. Defaults to
#   true.
# [*manage_report_processor*]
#   Optional boolean. If this module should manage the `reports` setting in
#   `puppet.conf`. Defaults to true.
# [*manage_confdir*]
#   Optional boolean. If this module should manage Puppet's confdir as a file
#   resource. Defaults to true.
# [*masterless*]
#   Optional boolean. If this is a masterless puppet implementation. This tells
#   us the section in which to place the report processor configuration in
#   puppet.conf.
# [*confdir*]
#   Optional string. The directory of your Puppet configuration. Defaults to
#   $::settings::confdir.
#
class scribe_reporter (
  $hosts,
  $category                = $scribe_reporter::params::category,
  $manage_package          = $scribe_reporter::params::manage_package,
  $manage_report_processor = $scribe_reporter::params::manage_report_processor,
  $manage_confdir          = $scribe_reporter::params::manage_confdir,
  $masterless              = $scribe_reporter::params::masterless,
  $confdir                 = $scribe_reporter::params::confdir,
) inherits scribe_reporter::params {

  $config_hash = {
    hosts    => any2array($hosts),
    category => $category,
  }

  file { "${confdir}/scribe.yaml":
    ensure  => file,
    content => inline_template('<%= @config_hash.to_yaml %>')
  }

  if $manage_confdir {
    ensure_resource(file, $confdir, { ensure => directory })
  }

  if $manage_package {
    package { 'scribe':
      ensure   => present,
      provider => gem
    }

    Package['scribe'] -> File["${confdir}/scribe.yaml"]
  }

  if $manage_report_processor {
    if $masterless {
      $puppet_conf_section = 'main'
    } else {
      $puppet_conf_section = 'master'
    }

    ini_subsetting { 'puppet.conf/reports/scribe':
      ensure               => present,
      path                 => "${confdir}/puppet.conf",
      section              => $puppet_conf_section,
      setting              => 'reports',
      subsetting           => 'puppetdb',
      subsetting_separator => ',',
      require              => File["${confdir}/scribe.yaml"]
    }
  }
}
