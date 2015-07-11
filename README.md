[![Puppet Forge](http://img.shields.io/puppetforge/v/danzilio/scribe_reporter.svg?style=flat)](https://forge.puppetlabs.com/danzilio/scribe_reporter) [![Build Status](https://travis-ci.org/danzilio/puppet-scribe_reporter.svg)](https://travis-ci.org/danzilio/puppet-scribe_reporter) [![Documentation Status](http://img.shields.io/badge/docs-puppet--strings-ff69b4.svg?style=flat)](http://danzilio.github.io/puppet-scribe_reporter)

This is a report processor for Puppet that sends the raw Puppet reports to a [Scribe](https://github.com/facebookarchive/scribe) log server. This processor requires the `scribe` [gem](https://github.com/twitter/scribe). This module also contains a `scribe_reporter` class to manage the configuration file and gem. This module depends on the [report_all_the_things](https://github.com/danzilio/puppet-report_all_the_things) module.

## Requirements

- `puppet` (this module is tested with 2.7 and up)
- `stdlib`
- `scribe` gem
- `report_all_the_things` module
- `inifile` module

## Usage

To begin using the `scribe_reporter` module, you must pass the `hosts` parameter. The class expects a string or array of strings:

    class { 'scribe_reporter':
      hosts => [ 'scribe1.example.com:1463', 'scribe2.example.com:1463' ]
    }

This will do three main things:

1. install the `scribe` gem
2. place configuration file in `$confdir/scribe.yaml` (usually `/etc/puppet/scribe.yaml` or `/etc/puppetlabs/scribe.yaml`).
4. add `scribe` as a report processor in `puppet.conf`

The report processor will be synced via pluginsync. Once Puppet has run with this module, it will begin to submit reports to Scribe.

If you don't wish to manage the `reports` setting in `puppet.conf` you can set `manage_report_processor` to `false`:

    class { 'scribe_reporter':
      hosts => [ 'scribe1.example.com:1463', 'scribe2.example.com:1463' ],
      manage_report_processor => false,
    }

If you're running in `masterless` mode, we need to configure the `reports` setting in the `main` section of `puppet.conf` instead of the `master` section. To do this you need to set the `masterless` parameter to `true`:

    class { 'scribe_reporter':
      hosts      => [ 'scribe1.example.com:1463', 'scribe2.example.com:1463' ],
      masterless => true
    }

If you don't want this module to manage the `scribe` gem, you can set the `manage_package` parameter to `false`:

    class { 'scribe_reporter':
      hosts          => [ 'scribe1.example.com:1463', 'scribe2.example.com:1463' ],
      manage_package => false
    }

If you choose to manage the `scribe` gem manually, don't forget to install it with the appropriate `gem` command before trying to send reports to Scribe.

    gem install scribe

## Development

1. Fork it
2. Create a feature branch
3. Write a failing test
4. Write the code to make that test pass
5. Refactor the code
6. Submit a pull request

We politely request (demand) tests for all new features. Pull requests that contain new features without a test will not be considered. If you need help, just ask!
