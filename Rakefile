# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'hoe/signing'

Hoe.plugin :yard

Hoe.spec('parameters') do
  self.developer('Postmodern','postmodern.mod3@gmail.com')

  self.rspec_options += ['--colour', '--format', 'specdoc']

  self.yard_opts += ['--protected']
  self.remote_yard_dir = '/'

  self.extra_dev_deps += [
    ['rspec', '>=1.2.9']
  ]
end

# vim: syntax=Ruby
