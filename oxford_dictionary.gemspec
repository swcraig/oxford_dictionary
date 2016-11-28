# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oxford_dictionary/version'

Gem::Specification.new do |spec|
  spec.name          = 'oxford_dictionary'
  spec.version       = OxfordDictionary::VERSION
  spec.authors       = ['swcraig']

  spec.summary       = 'A wrapper for the Oxford Dictionary API'
  spec.description   = 'https://developer.oxforddictionaries.com/documentation'
  spec.homepage      = 'https://github.com'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 2.1.0'

  spec.add_runtime_dependency 'httparty', '~> 0.14.0'
  spec.add_runtime_dependency 'hashie', '~> 3.4.6'
end
