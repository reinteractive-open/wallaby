# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.7.1'

# Declare your gem's dependencies in wallaby.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]
# gem 'rails', git: 'https://github.com/rails/rails', branch: 'master'
gem 'wallaby-cop', path: '../wallaby-cop'
gem 'wallaby-core', path: '../wallaby-core'
gem 'wallaby-view', path: '../wallaby-view'

gem 'wallaby-active_record', path: '../wallaby-active_record'

# gem 'activestorage'
gem 'cancancan'
gem 'kaminari'
gem 'pundit'
gem 'rails', '~> 6.0.0'
# gem 'simple_blog_theme', git: 'https://github.com/wallaby-rails/simple_blog_theme.git', branch: 'master'
gem 'simple_blog_theme', path: '../simple_blog_theme'
gem 'will_paginate'

# gem 'font-awesome-sass', '< 5.0'

group :development, :test do
  gem 'binding_of_caller'
  gem 'byebug'
  gem 'devise'
  gem 'ffaker'
  gem 'mysql2'
  # gem 'pg', '~> 0.15'
  gem 'pg'
  gem 'pry-rails'
  gem 'rspec-rails', '4.0.0.beta3'
  gem 'sqlite3'
  # gem 'sqlite3', '< 1.4.0'
  gem 'yard'
end

group :development do
  gem 'massa'
  gem 'memory_profiler'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'turbolinks'
end

# @see https://github.com/sass/sassc-ruby/issues/146
# TODO: remove this line when it's resolved
gem 'sassc', '< 2.2.0'

group :test do
  gem 'database_cleaner'
  gem 'deep-cover'
  gem 'just-the-docs'
  gem 'jekyll'
  gem 'generator_spec'
  gem 'rails-controller-testing'
  gem 'simplecov', '~> 0.17.0'
  gem 'webmock'
end
