# encoding: utf-8

require 'json'
require 'ostruct'

require 'support/fake_ec2'
require 'support/resource'

require 'simplecov'

SimpleCov.start do
  add_group 'Source', 'lib'
  add_group 'Unit tests', 'spec/erforscher'
  add_group 'Acceptance tests', 'spec/acceptance'
end

require 'erforscher'
