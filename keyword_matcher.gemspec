lib = File.expand_path('lib', __dir__)
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
  spec.required_ruby_version = ['>= 2.4.0', '< 2.6.0']

  spec.add_runtime_dependency 'activesupport', '>= 4.0'
  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 12.3', '>= 12.3.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.76.0'
end
