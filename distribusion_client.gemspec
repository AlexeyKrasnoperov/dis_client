# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = 'distribusion_client'
  spec.version       = '0.1'
  spec.summary       = 'The One Routes Client.'
  spec.description   = 'Client for The One Challenge.'
  spec.authors       = ['Alexey Krasnoperov']
  spec.email         = 'Alexey.Krasnoperov@gmail.com'
  spec.files       = Dir['{lib}/**/*']
  spec.test_files  = Dir['spec/**/*']
  spec.homepage = 'http://github.com/matsarello/distribusion_client'

  spec.add_dependency('virtus')
  spec.add_dependency('rubyzip')
end
