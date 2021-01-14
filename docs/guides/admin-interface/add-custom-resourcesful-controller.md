---
title: Add Custom Resourcesful Controller
layout: default
nav_order: 3

parent: Admin Interface
grand_parent: Guides
has_children: true
---

# Add Custom Resourcesful Controller

This document outlines how to add custom resourcesful controller:

Assume that:

- Wallaby is mounted at `/admin`
- ActiveRecord model is `Product`

To add custom resourcesful controller `Admin::CustomProductsController`, the steps are:

- Create the routes in `config/routes.rb`:

  ```ruby
  Rails.application.routes.draw do
    wallaby_mount at: '/admin' do
      resources :custom_products
    end
  end
  ```

- Create a custom controller inheriting from the admin interface application controller as `app/controllers/admin/custom_products_controller.rb`:

  ```ruby
  class Admin::CustomProductsController < Admin::ApplicationController
  end
  ```

  > NOTE: `Admin::ApplicationController` can be replaced with `Wallaby::ResourcesController` if it doesn't not exist.

- Tell controller that its model class is `Product` if Wallaby doesn't know which model class to use for this controller:

  ```ruby
  class Admin::CustomProductsController < Admin::ApplicationController
    self.model_class = Product
  end
  ```
