# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'aranha/parsers/version'

Gem::Specification.new do |s|
  s.name        = 'aranha-parsers'
  s.version     = ::Aranha::Parsers::VERSION
  s.authors     = ['Esquilo Azul Company']
  s.summary     = 'Parsers\' utilities for Ruby.'

  s.files = Dir['{lib}/**/*']

  s.add_dependency 'activesupport', '>= 4.0.0'
  s.add_dependency 'addressable', '~> 2.8', '>= 2.8.3'
  s.add_dependency 'eac_ruby_utils', '~> 0.112'
  s.add_dependency 'faraday', '~> 2.7', '>= 2.7.4'
  s.add_dependency 'faraday-follow_redirects', '~> 0.3'
  s.add_dependency 'faraday-gzip', '~> 0.1'
  s.add_dependency 'faraday-retry', '~> 2.1'
  s.add_dependency 'nokogiri', '~> 1.14', '>= 1.14.2'
  s.add_dependency 'ofx-parser', '~> 1.1'

  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.5.1'
end
