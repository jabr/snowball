# encoding: utf-8

require './uuid'

Gem::Specification.new do |gem|
  gem.name        = 'snowball'
  gem.version     = '0.1.0'
  gem.authors     = ['Justin Bradford']
  gem.email       = 'justin@etcland.com'
  gem.description = 'Ruby Snowball UUID'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/jabr/snowball'
  gem.licenses    = %w[MIT]

  gem.require_paths    = %w[lib]
  gem.files            = `git ls-files`.split($/)
  gem.test_files       = `git ls-files -- spec/{unit,integration}`.split($/)
  gem.extra_rdoc_files = %w[LICENSE README.md CONTRIBUTING.md TODO]

  gem.required_ruby_version = '>= 1.9.3'
end
