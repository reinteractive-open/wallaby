# [Wallaby](https://github.com/wallaby-rails/wallaby)

[![Gem Version](https://badge.fury.io/rb/wallaby.svg)](https://badge.fury.io/rb/wallaby)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Travis CI](https://travis-ci.org/wallaby-rails/wallaby.svg?branch=master)](https://travis-ci.org/wallaby-rails/wallaby)
[![Maintainability](https://api.codeclimate.com/v1/badges/5b94a30d79f3b6d8c4ce/maintainability)](https://codeclimate.com/github/wallaby-rails/wallaby/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/5b94a30d79f3b6d8c4ce/test_coverage)](https://codeclimate.com/github/wallaby-rails/wallaby/test_coverage)
[![Inch CI](https://inch-ci.org/github/wallaby-rails/wallaby.svg?branch=master)](https://inch-ci.org/github/wallaby-rails/wallaby)

Wallaby autocompletes typical resourcesful actions (including controller and view) for ORM models. Therefore, it can be used to generate Admin Interface or speed up Rails development.

It can be easily customized at different MVC aspects:

- [controllers](https://github.com/wallaby-rails/wallaby/blob/master/docs/controllers.md) - used to overwrite the default resourcesful actions.
- [decorators](https://github.com/wallaby-rails/wallaby/blob/master/docs/decorator.md) - used by the view to control what fields are rendered in what format.
- [type partials](https://github.com/wallaby-rails/wallaby/blob/master/docs/view.md) - the corresponding templates rendered for the fields defined in decorator.
- [servicers](https://github.com/wallaby-rails/wallaby/blob/master/docs/servicer.md) -
- [authorizers](https://github.com/wallaby-rails/wallaby/blob/master/docs/authorizer.md) - used as the authorization helper
- [paginators](https://github.com/wallaby-rails/wallaby/blob/master/docs/paginator.md) - used as the pagination helper
- [themes](https://github.com/wallaby-rails/wallaby/blob/master/docs/theme.md) - complete sets of templates and partials implemented for specific purposes

Currently, it supports ActiveRecord models and can be used together with CanCanCan and Pundit. Besides, it can be extended to support any ORM models and authorization frameworks.

[Try the demo here](https://wallaby-demo.herokuapp.com/admin/) or take a look at the following screenshots:

[![Animated Demo](https://raw.githubusercontent.com/wallaby-rails/wallaby/master/docs/demo-animated.gif)](https://raw.githubusercontent.com/wallaby-rails/wallaby/master/docs/demo-animated.gif)

## Install

1. Add Wallaby to `Gemfile`.

  ```ruby
  # Gemfile
  gem 'wallaby'
  ```

2. Re-bundle.

  ```shell
  bundle install
  ```

## Basic Usage

### As Admin Interface

- Just mount Wallaby engine to desired path (e.g. `/admin`) in `config/routes.rb`.

  ```ruby
  # config/routes.rb
  wallaby_mount at: '/admin'
  ```

- Or run installer to generate default application classes and templates under namespace e.g. **Admin** and mount Wallaby engine to path `/admin`.

  ```shell
  rails g wallaby:install admin
  ```

Restart rails server, and visit http://localhost:3000/admin to start exploring!

### For General Purposes

> Since 6.3.0

Instead of using Rails scaffold generator to generate all the boilerplate code, Wallaby can help to quickly get the pages up for ordinary resourcesful actions.

For example, once an ActiveRecord model **Blog** is created:

```shell
rails generate model blog title:string body:text
rails db:migrate
```

To spin up things:

1. Add blogs controller and include **Wallaby::ResourcesConcern**.

  ```ruby
  # app/controllers/blogs_controller.rb
  class BlogsController < ApplicationController
    include Wallaby::ResourcesConcern
  end
  ```

2. Add corresponding resources route using **resources** helper

  ```ruby
  # config/routes.rb
  resources :blogs
  ```

It's possible to quickly apply a theme to save tuns of hours building an app. To do that, it goes:

1. Add the theme gem to `Gemfile` then re-bundle:

  ```ruby
  # Gemfile
  gem 'simple_blog_theme', git: 'https://github.com/wallaby-rails/simple_blog_theme.git', branch: 'master'
  ```

2. Set the theme name in the controller:

  ```ruby
  # app/controllers/blogs_controller.rb
  class BlogsController < ApplicationController
    include Wallaby::ResourcesConcern
    self.theme_name = 'simple_blog_theme'
  end
  ```

> NOTE: `wallaby` gem itself is just a theme as well, all the core funcationalities are in [wallaby-core](https://github.com/wallaby-rails/wallaby-core) gem.

Restart rails server, and visit http://localhost:3000/blogs to give it a go!

## Documentation

- [Features](https://github.com/wallaby-rails/wallaby/blob/master/docs/features.md)
- HOWTOs:
  - Admin Interface:
    - [Customize a typical resourcesful action]()
    - [Add a non-resourcesful action]()
    - []
- All MVC aspects:
  - [controllers](https://github.com/wallaby-rails/wallaby/blob/master/docs/controllers.md) - used to overwrite the default resourcesful actions.
  - [decorators](https://github.com/wallaby-rails/wallaby/blob/master/docs/decorator.md) - used by the view to control what fields are rendered in what format.
  - [type partials](https://github.com/wallaby-rails/wallaby/blob/master/docs/view.md) - the corresponding templates rendered for the fields defined in decorator.
  - [servicers](https://github.com/wallaby-rails/wallaby/blob/master/docs/servicer.md) -
  - [authorizers](https://github.com/wallaby-rails/wallaby/blob/master/docs/authorizer.md) - used as the authorization helper
  - [paginators](https://github.com/wallaby-rails/wallaby/blob/master/docs/paginator.md) - used as the pagination helper
  - [themes](https://github.com/wallaby-rails/wallaby/blob/master/docs/theme.md) - complete sets of templates and partials implemented for specific purposes
- [Core API Reference](https://www.rubydoc.info/gems/wallaby-core)
- Change Logs:
  - [wallaby](https://github.com/wallaby-rails/wallaby/blob/master/CHANGELOG.md)
  - [wallaby-core](https://github.com/wallaby-rails/wallaby-core/blob/master/CHANGELOG.md)

## Want to contribute?

Raise an issue, discuss and resolve!

## License

This project uses [MIT License](https://github.com/wallaby-rails/wallaby/blob/master/LICENSE).
