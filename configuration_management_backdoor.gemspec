$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'configuration_management_backdoor/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'configuration_management_backdoor'
  s.version     = ConfigurationManagementBackdoor::VERSION
  s.authors     = ['Thomas Schank']
  s.email       = ['DrTom@schank.ch']
  s.homepage    = 'https://github.com/DrTom/rails_configuration-management-backdoor'
  s.summary     = 'Configuration Management Backdoor for Ruby on Rails'
  s.description = 'See summary.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE',
                'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '>= 5.0', '< 6.0'

  s.add_development_dependency 'rubocop'
end
