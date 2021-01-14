# Declaring Routes

Routes can be declared in the following scenarios:

- [As Admin Interface](#as-admin-interface)
  - [`:resources_controller` mount option](#resources_controller-mount-option) (since 5.2.0) - to specify the base controller for a given mount path
  - [route for custom action](#route-for-custom-action)
- [As Non Admin Interface](#as-non-admin-interface) (since 5.2.0)
  - [Resources](#resources)
  - [Singular Resources](#singular-resources)

Read more:

- [Path and URL Helpers](#path-and-url-helpers) for the full list of predefined routes and helpers.

## As Admin Interface

When Wallaby is used as an admin interface, generally, it can be mounted as below:

```ruby
# config/routes.rb
mount Wallaby::Engine, at: '/admin'
```

Once it is mounted at `/admin`, all URLs prefixed with `/admin` will be handled by Wallaby [Resources Router](https://www.rubydoc.info/gems/wallaby/Wallaby/ResourcesRouter), which will dispatch resourcesful Rails request to corresponding action (**index**/**new**/**create**/**show**/**edit**/**update**/**destroy**).

### `:resources_controller` mount option

> since 5.2.0

When mounting Wallaby at different path, it's possible to specify different base controller class for different mount path using `:resources_controller` defaults option. For example:

```ruby
# app/controllers/super_admin/application_controller.rb
class SuperAdmin::ApplicationController < Wallaby::ResourcesController
end

# app/controllers/advisor_only/application_controller.rb
class AdvisorOnly::ApplicationController < Wallaby::ResourcesController
end

# config/routes.rb
mount Wallab::Engine,
  at: '/super_admin', as: :super_admin,
  defaults: { resources_controller: SuperAdmin::ApplicationController }

mount Wallab::Engine,
  at: '/advisor', as: :advisor,
  defaults: { resources_controller: AdvisorOnly::ApplicationController }
```

Then you have two admin apps, one for admin, one for advisor, with different base controllers and different purposes.

### route for custom action

Given the following controller and member action:

```ruby
# app/controllers/admin/products_controller.rb
class Admin::ProductsController < Admin::ApplicationController
  def mark_shipped
    resource.mark_shipped
  end
end
```

Then route should be declared before Wallaby's mount statement:

```ruby
# config/routes.rb
get 'admin/products/:id/mark_shipped', to: 'admin/products#mark_shipped'

mount Wallaby::Engine, at: '/admin'
```

## As Non Admin Interface

### Resources

> since 5.2.0

Wallaby can be used beyond being an admin interface. For example, it can be used to quickly generate a page for an existing model (e.g. `Product`) without the need of adding any custom controller, the resourcesful route can be declared as:

```ruby
# config/routes.rb
wresources :products, controller: 'wallaby/resources'
# It has the same effect as the origin Rails route declaration below:
resources :products,
  controller: 'wallaby/resources', path: ':resources',
  defaults: { resources: :products }, constraints: { resources: :products }
```

If custom controller exists as below:

```ruby
# app/controllers/products_controller.rb
class ProductsController < Wallaby::ResourcesController
  def orders
    @orders = Order.for resource
  end
end
```

Then the route to declare will just be:

```ruby
# config/routes.rb
resources :products
```

### Singular Resources

> since 5.2.0

Wallaby can be also used for singular resourcesful actions (new/create/show/edit/update/destroy). For example, for a model `Profile`, singular resource routes can be declared as:

```ruby
# config/routes.rb
wresource :profile, controller: 'wallaby/resources'
# It has the same effect as the origin Rails route declaration below:
resource :profile,
  controller: 'wallaby/resource', path: ':resource',
  defaults: { resource: :profile, resources: :profiles },
  constraints: { resource: :profile, resources: :profiles }
```

If custom controller exists:

```ruby
# app/controllers/profile_controller.rb
class ProfileController < Wallaby::ResourcesController
end
```

Then the route to declare will just be:

```ruby
# config/routes.rb
wresource :profile
```

## Path and URL Helpers

Similar to [Rails Resourceful Path and URL helpers ](http://guides.rubyonrails.org/routing.html#path-and-url-helpers), Wallaby provides a set of resourcesful path and URL helpers when it is used as an admin interface, for example:

| HTTP Verb |	Path	                        | Named Helper                                            | Controller#Action         | Mounted Path  | Engine Name     | Resources Name  |
| --------- | ----------------------------- | ------------------------------------------------------- | ------------------------- | ------------- | --------------- | --------------- |
| GET       |	/admin/order::items	          | _wallaby_engine.resources_path('order::items')_         | admin/order/items#index	  | /admin        | wallaby_engine  | order::items    |
| GET       |	/admin/order::items/new	      | _wallaby_engine.new_resource_path('order::items')_      | admin/order/items#new	    | /admin        | wallaby_engine  | order::items    |
| POST      |	/admin/order::items	          | _wallaby_engine.resources_path('order::items')_         | admin/order/items#create	| /admin        | wallaby_engine  | order::items    |
| GET       |	/admin/order::items/:id	      | _wallaby_engine.resource_path('order::items',:id)_      | admin/order/items#show	  | /admin        | wallaby_engine  | order::items    |
| GET       |	/admin/order::items/:id/edit  | _wallaby_engine.edit_resource_path('order::items',:id)_ | admin/order/items#edit	  | /admin        | wallaby_engine  | order::items    |
| PATCH/PUT |	/admin/order::items/:id	      | _wallaby_engine.edit_resource_path('order::items',:id)_ | admin/order/items#update	| /admin        | wallaby_engine  | order::items    |
| DELETE    |	/admin/order::items/:id	      | _wallaby_engine.resource_path('order::items',:id)_      | admin/order/items#destroy | /admin        | wallaby_engine  | order::items    |

> **Mounted Path** is also known as [Script Name](http://api.rubyonrails.org/classes/ActionDispatch/Routing/Redirection.html)

### Engine Helper

If Wallaby is used as an admin interface and mounted without `:as` option, by default, Rails will generate an engine helper called `wallaby_engine`, so that resourcesful path helper methods can be accessed via this engine helper:

```ruby
wallaby_engine.resources_path('order::items') # => /admin/order::items
```

When an alias engine name is specified by `:as` option as follows (see [#mount](http://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Base.html#method-i-mount)):

```ruby
# config/routes.rb
mount Wallaby::Engine, at: '/admin', as: :manager_engine
```

Rails will generate the engine helper as `manager_engine` instead. Then resourcesful path helper methods can be accessed:

```ruby
manager_engine.resources_path('order::items')
```

Most of the time, Wallaby should be able to determine what engine name to use. But if Wallaby can't detect the engine name, it can be configured in controller (also see [Controller - Advanced Customization -> engine_name](advanced_controller.md#engine_name)):

```ruby
# app/controllers/admin/application_controller.rb
class Admin::ApplicationController < Wallaby::ResourcesController
  self.engine_name = :manager_engine
end
```

> NOTE: All subclasses of `Admin::ApplicationController` will inherit the same engine name when it is set.

> See more options at [Customizing Controller](controller.md).
