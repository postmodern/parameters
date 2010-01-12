# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'hoe/signing'

Hoe.plugin :yard

Hoe.spec('parameters') do
  self.rubyforge_name = 'parameters'
  self.developer('Postmodern','postmodern.mod3@gmail.com')

  self.rspec_options += ['--colour', '--format', 'specdoc']

  self.remote_yard_dir = '/'

  self.extra_dev_deps += [
    ['rspec', '>=1.2.9']
  ]
end

# vim: syntax=Ruby
