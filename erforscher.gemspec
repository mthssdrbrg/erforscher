# encoding: utf-8

$: << File.expand_path('../lib', __FILE__)

require 'erforscher/version'


Gem::Specification.new do |s|
  s.name        = 'erforscher'
  s.version     = Erforscher::VERSION
  s.authors     = ['Mathias Söderberg']
  s.email       = ['mths@sdrbrg.se']
  s.homepage    = 'https://github.com/mthssdrbrg/erforscher'
  s.summary     = %q{AWS EC2 API service discovery tool}
  s.description = %q{Poor man's service discovery tool using AWS EC2 APIs}
  s.license     = 'Apache License 2.0'

  s.files         = Dir['lib/**/*.rb', 'bin/*', 'README.md']
  s.test_files    = Dir['spec/**/*.rb']
  s.executables   = %w(erforscher)

  s.add_dependency 'aws-sdk-core'

  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.3'
end