---
title: Customize a Resourcesful Action
layout: default
nav_order: 1

parent: Admin Interface
grand_parent: Guides
has_children: true
---

# Customize a Resourcesful Action

This document outlines how to customize a resourcesful action e.g. `show`:

Assume that:

- Wallaby is mounted at `/admin`
- ActiveRecord model is `Product`

To customize the resourcesful action `show`, the steps are:

- Create a custom controller inheriting from the admin interface application controller as `app/controllers/admin/products_controller.rb`:

  ```ruby
  class Admin::ProductsController < Admin::ApplicationController
  end
  ```

  > NOTE: `Admin::ApplicationController` can be replaced with `Wallaby::ResourcesController` if it doesn't not exist.

- Create the action method `show`:

  ```ruby
  class Admin::ProductsController < Admin::ApplicationController
    def show
      # override the original method
    end
  end
  ```
