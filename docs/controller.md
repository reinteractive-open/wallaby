## Controller

Wallaby allows devs to customize controller logics in a custom controller that inherits from `Wallaby::ResourcesController`.

- [Declaration](#declaration)

The following resourceful actions can be customized:

- [Home](#home)
- [Index](#index)
- [Show](#show)
- [New](#new)
- [Create](#create)
- [Edit](#edit)
- [Update](#update)
- [Destroy](#destroy)

Also it is possible to customize the whitelisting parameters for mass assignment of create/update:

- [Strong Parameters](#strong_parameters)

### Declaration

Let's see how a controller can be created so that Wallaby knows its existence. Similar to what it is normally done in Rails, create a custom controller for model `Product` that inherits from `Wallaby::ResourcesController` as below:

```ruby
#!app/controllers/products_controller.rb
class ProductsController < Wallaby::ResourcesController
end
```

> NOTE: although it inherits `Wallaby::ResourcesController`, it is possible to access to all methods in `ApplicationController`. Because `Wallaby::ResourcesController` inherits `ApplicationController` unless this is changed in Wallaby [authentication configuration](configuration.md#authentication).

If `ProductsController` is taken, it is still possible to use another name, however the method `self.model_class` must be defined to specify the model as the example below:

```ruby
#!app/controllers/admin/products_controller.rb
class Admin::ProductsController < Wallaby::ResourcesController
  def self.model_class
    Product
  end
end
```

### Home

`home` action is basically a blank action which renders the `home` template as the landing page of Wallaby (the root_path of where Wallaby engine is mounted) (available since 5.1.0):

```ruby
def home
  # do nothing
end
```

that it can be completely replaced with your own implementation.

### Index

- To add functionality before the action, it is fine to either use `before_action` or:

    ```ruby
    class ProductsController < Wallaby::ResourcesController
      def index
        # do something here
        # to access the records, use `collection`
        collection
        # to re-assign the collection, assign to `@collection`
        @collection = @collection.where(created_at: Date.today)
        super
      end
    end
    ```

- To add functionality after the action but before rendering, it goes:

    ```ruby
    class ProductsController < Wallaby::ResourcesController
      def index
        super do
          # do something here before rendering
        end
      end
    end
    ```

Basically, `index` action is simple as:

```ruby
def index
  authorize! :index, current_model_class
  yield if block_given? # after_index
  respond_with collection
end
```

that it can be completely replaced, just need to bear in mind that `@collection` is needed in the view.

### Show

- To add functionality before the action, it is fine to either use `before_action` or:

    ```ruby
    class ProductsController < Wallaby::ResourcesController
      def show
        # do something here
        # to access the record, use `resource`
        resource
        # to re-assign the resource, assign to `@resource`
        @resource = Product.first
        super
      end
    end
    ```

- To add functionality after the action but before rendering, it goes:

    ```ruby
    class ProductsController < Wallaby::ResourcesController
      def show
        super do
          # do something here before rendering
        end
      end
    end
    ```

Basically, `show` action is simple as:

```ruby
def show
  authorize! :show, resource
  yield if block_given? # after_show
  respond_with resource
end
```

that it can be completely replaced, just need to bear in mind that `@resource` is needed in the view.

### New

- To add functionality before the action, it is fine to either use `before_action` or:

    ```ruby
    class ProductsController < Wallaby::ResourcesController
      def new
        # do something here
        # to access the record, use `resource`
        resource
        # to re-assign the resource, assign to `@resource`
        @resource = Product.new(new_arrival: true)
        super
      end
    end
    ```

- To add functionality after the action but before rendering, it goes:

    ```ruby
    class ProductsController < Wallaby::ResourcesController
      def new
        super do
          # do something here before rendering
        end
      end
    end
    ```

Basically, `new` action is simple as:

```ruby
def new
  authorize! :new, resource
  yield if block_given? # after_new
  respond_with resource
end
```

that it can be completely replaced, just need to bear in mind that `@resource` is needed in the view.

### Create

- To add functionality before the action, it is fine to either use `before_action` or:

    ```ruby
    class ProductsController < Wallaby::ResourcesController
      def create
        # do something here before saving the record
        # to access the record, use `resource`
        resource
        # to re-assign the resource, assign to `@resource`
        @resource = Product.new(new_arrival: true)
        super
      end
    end
    ```

- To add functionality after the action but before rendering, it goes:

    ```ruby
    class ProductsController < Wallaby::ResourcesController
      def create
        super do
          # do something here before rendering
        end
      end
    end
    ```

Basically, `create` action is simple as:

```ruby
def create
  authorize! :create, resource
  current_model_service.create resource, params
  yield if block_given? # after_create
  respond_with resource, location: helpers.show_path(resource)
end
```

that it can be completely replaced, just need to bear in mind that `@resource` is needed.

### Edit

- To add functionality before the action, it is fine to either use `before_action` or:

    ```ruby
    class ProductsController < Wallaby::ResourcesController
      def edit
        # do something here
        # to access the record, use `resource`
        resource
        # to re-assign the resource, assign to `@resource`
        @resource = Product.find_by(id: param[:id], owner_id: current_user.id)
        super
      end
    end
    ```

- To add functionality after the action but before rendering, it goes:

    ```ruby
    class ProductsController < Wallaby::ResourcesController
      def edit
        super do
          # do something here before rendering
        end
      end
    end
    ```

Basically, `edit` action is simple as:

```ruby
def edit
  authorize! :edit, resource
  yield if block_given? # after_edit
  respond_with resource
end
```

that it can be completely replaced, just need to bear in mind that `@resource` is needed in the view.

### Update

- To add functionality before the action, it is fine to either use `before_action` or:

    ```ruby
    class ProductsController < Wallaby::ResourcesController
      def update
        # do something here before saving the record
        # to access the record, use `resource`
        resource
        # to re-assign the resource, assign to `@resource`
        @resource = Product.new(new_arrival: true)
        super
      end
    end
    ```

- To add functionality after the action but before rendering, it goes:

    ```ruby
    class ProductsController < Wallaby::ResourcesController
      def update
        super do
          # do something here before rendering
        end
      end
    end
    ```

Basically, `update` action is simple as:

```ruby
def update
  authorize! :update, resource
  current_model_service.update resource, params
  yield if block_given? # after_update
  respond_with resource, location: helpers.show_path(resource)
end
```

that it can be completely replaced, just need to bear in mind that `@resource` is needed.

### Destroy

- To add functionality before the action, it is fine to either use `before_action` or:

    ```ruby
    class ProductsController < Wallaby::ResourcesController
      def destroy
        # do something here before saving the record
        # to access the record, use `resource`
        resource
        # to re-assign the resource, assign to `@resource`
        @resource = Product.new(new_arrival: true)
        super
      end
    end
    ```

- To add functionality after the action but before rendering, it goes:

    ```ruby
    class ProductsController < Wallaby::ResourcesController
      def destroy
        super do
          # do something here before rendering
        end
      end
    end
    ```

Basically, `destroy` action is simple as:

```ruby
def destroy
  authorize! :destroy, resource
  current_model_service.destroy resource, params
  yield if block_given? # after_destroy
  respond_with resource, location: helpers.index_path(current_model_class)
end
```

that it can be completely replaced with your own implementation.

### Strong Parameters

To customize the parameters to be whitelisted for create and update, just override `resource_params` in your controller. The underlying is using [servicer's `permit` method](servicer.md#permit)


```ruby
class ProductsController < Wallaby::ResourcesController
  def resource_params
    params.require(:product).permit(:name, :sku)
  end
end
```
