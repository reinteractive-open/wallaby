# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'wallaby/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = 'wallaby'
  s.version = Wallaby::VERSION
  s.authors = ['Tianwen Chen']
  s.email = ['me@tian.im']
  s.homepage = 'https://github.com/wallaby-rails/wallaby'
  s.summary = 'Autocomplete the resourcesful actions and views for ORMs for admin interface and other purposes.'
  s.description = s.summary
  s.license = 'MIT'

  s.files = Dir[
    '{app,config,db,lib,vendor}/**/*',
    'LICENSE',
    'README.md',
    # docs:begin
    '{docs}/**/*',
    '_config.yml',
    '_sass/custom/custom.scss',
    'index.md',
    # docs:end
  ]

  s.add_dependency 'wallaby-core'

  # This will determine wallaby-core's version
  s.add_dependency 'wallaby-active_record', '0.3.0'

  # assets gems
  s.add_dependency 'bootstrap'
  s.add_dependency 'bootstrap4-datetime-picker-rails'
  s.add_dependency 'font-awesome-sass'
  s.add_dependency 'jbuilder'
  s.add_dependency 'jquery-minicolors-rails'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'momentjs-rails'
  s.add_dependency 'sass-rails'
  s.add_dependency 'summernote-rails'
  s.add_dependency 'twitter-typeahead-rails'

  s.add_development_dependency 'wallaby-cop'
  s.add_development_dependency 'wallaby-her'
end
