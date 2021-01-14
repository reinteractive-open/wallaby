---
title: Add a Non-resourcesful Action
layout: default
nav_order: 2

parent: Admin Interface
grand_parent: Guides
has_children: true
---

# Add a Non-resourcesful Action

This document outlines how to add a non-resourcesful action e.g. `export`:

Assume that:

- Wallaby is mounted at `/admin`
- ActiveRecord model is `Product`

To add a non-resourcesful action `export`, the steps are:

- Create the routes in `config/routes.rb`:

  ```ruby
  Rails.application.routes.draw do
    wallaby_mount at: '/admin' do
      resources :products do
        get :export, on: :collection
      end
    end
  end
  ```

- Create a custom controller inheriting from the admin interface application controller as `app/controllers/admin/products_controller.rb`:

  ```ruby
  class Admin::ProductsController < Admin::ApplicationController
  end
  ```

  > NOTE: `Admin::ApplicationController` can be replaced with `Wallaby::ResourcesController` if it doesn't not exist.

- Create the action method `export`:

  ```ruby
  class Admin::ProductsController < Admin::ApplicationController
    def export
      # do something
    end
  end
  ```

- Add the export link to a proper place in the page.
