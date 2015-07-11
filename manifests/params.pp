# == Class: scribe_reporter::params
#
class scribe_reporter::params {
  $category                = 'puppet'
  $manage_package          = true
  $manage_report_processor = true
  $manage_confdir          = true
  $masterless              = false
  $confdir                 = $::settings::confdir
}
