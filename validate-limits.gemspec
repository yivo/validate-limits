# encoding: UTF-8
# frozen_string_literal: true

require File.expand_path('../lib/validate-limits/version', __FILE__)

Gem::Specification.new do |s|
  s.name            = 'validate-limits'
  s.version         = ValidateLimits::VERSION
  s.author          = 'Yaroslav Konoplov'
  s.email           = 'eahome00@gmail.com'
  s.summary         = 'Automatically validate limits for ActiveRecord attributes.'
  s.description     = 'Automatically validate limits for ActiveRecord attributes.'
  s.homepage        = 'https://github.com/yivo/validate-limits'
  s.license         = 'MIT'

  s.files           = `git ls-files -z`.split("\x0")
  s.test_files      = `git ls-files -z -- {test,spec,features}/*`.split("\x0")
  s.require_paths   = ['lib']

  s.add_dependency 'activesupport',       '>= 3.0', '< 6.0'
  s.add_dependency 'activerecord',        '>= 3.0', '< 6.0'
end
