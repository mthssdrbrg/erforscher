# encoding: utf-8

$: << File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'erforscher'
  s.version     = '0.1.0'
  s.authors     = ['Mathias Söderberg']
  s.email       = ['mths@sdrbrg.se']
  s.homepage    = 'https://github.com/mthssdrbrg/erforscher'
  s.summary     = %q{}
  s.description = %q{}
  s.license     = 'Apache License 2.0'

  s.files         = Dir['lib/**/*.rb', 'README.md'] + Dir['bin/*']
  s.test_files    = Dir['spec/**/*.rb']
  s.require_paths = %w(lib)
  s.executables   = %w(erforscher)

  s.add_runtime_dependency 'aws-sdk-core'

  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.3'
end