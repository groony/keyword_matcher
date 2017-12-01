
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'keyword_matcher/version'

Gem::Specification.new do |spec|
  spec.name          = 'keyword_matcher'
  spec.version       = KeywordMatcher::VERSION
  spec.authors       = ['Ivan Novikov']
  spec.email         = ['ivan.novikov@saltpepper.ru']

  spec.summary       = 'Helps to match keywords with string of words'
  spec.homepage      = 'https://github.com/groony/keyword_matcher'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.4.0'

  spec.add_runtime_dependency 'activesupport', '~> 5.1'
  spec.add_runtime_dependency 'damerau-levenshtein', '~> 1.3'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.49.0'
end
