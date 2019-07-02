# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oxford_dictionary/version'

Gem::Specification.new do |spec|
  spec.name          = 'oxford_dictionary'
  spec.version       = OxfordDictionary::VERSION
  spec.authors       = ['swcraig']
  spec.email         = ['coverless.info@gmail.com']

  spec.summary       = 'A wrapper for the Oxford Dictionary API'
  spec.description   = 'https://developer.oxforddictionaries.com/documentation'
  spec.homepage      = 'https://github.com/swcraig/oxford-dictionary'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.45.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'vcr', '~> 5.0.0'

  spec.add_runtime_dependency 'plissken', '~> 0.1.0'
end
