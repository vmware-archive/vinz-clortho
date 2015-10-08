# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vinz/clortho/version'

Gem::Specification.new do |spec|
  spec.name          = 'vinz-clortho'
  spec.version       = Vinz::Clortho::VERSION
  spec.authors       = ['Liam Morley', 'Navya Canumalla']
  spec.email         = %w(lmorley@pivotal.io ncanumalla@pivotal.io)

  spec.summary       = %q{Git plugin for managing SSH authentication}
  spec.homepage      = 'https://github.com/pivotal/clortho'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test/|\.)}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'octokit', '~> 4.1.1'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-minitest'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'minitest'
  # spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'webmock'
end
