Gem::Specification.new do |spec|
  spec.name = 'homograph-detector'
  spec.version = '0.1.1'
  spec.authors = 'Kickstarter Engineering'
  spec.email = 'eng@kickstarter.com'
  spec.summary = %q{Ruby Gem used for homograph detection}
  spec.homepage = 'https://github.com/kickstarter/ruby-homograph-detector'
  spec.license = 'Apache-2.0'
  spec.files = `git ls-files`.split("\n")

  spec.add_dependency 'addressable', '~> 2.5'
  spec.add_dependency 'unicode-confusable', '~> 1.4'
  spec.add_dependency 'unicode-scripts', '~> 1.3'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'minitest', '~> 5.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'shoulda-context', '~> 1.2'
  spec.add_development_dependency 'simplecov', '~> 0.16.1'
end
