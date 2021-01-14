---
title: How It Works
layout: default
nav_order: 2
---

# How It Works
{: .no_toc }

This document outlines how things work behind the scenes of Wallaby:

## Table of Contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Resourcesful Actions

First of all, what does Wallaby do exactly? In short:

**Rails provides the framework to build resourcesful actions, Wallaby implements them for you.**

For example, model and controller for `Blog` are created using generators:

```sh
$ rails generate model Blog title:string text:text
$ rails generate controller Blogs
```

As soon as you include the module `Wallaby::ResourcesConcern` for `BlogsController`:

```ruby
class BlogsController < ApplicationController
  include Wallaby::ResourcesConcern
end
```

You will have all the resourcesful actions (`index`, `new`, `create`, `edit`, `update` and `destroy`) working immediately without the need of writing any boilerplate code.

In addition, Wallaby covers the other aspects including authentication, authorization and pagination.

Let's take a look at one of the resourcesful actions - `update` that Wallaby has implemented:

```ruby
def update(options = {}, &block)
  set_defaults_for :update, options
  current_authorizer.authorize :update, resource
  current_servicer.update resource, options.delete(:params)
  respond_with resource, options, &block
end
```

Basically, it is the same as what the following boilerplate code does:

```ruby
def update
  @resource = Blog.find params[:id]
  authorize @resource # Pundit
  @resource.update params.fetch(:blog, {}).permit(:title, :text)
  respond_with @resource # Responder
end
```

The magic is that Wallaby detects what ORM model it's dealing with,
so that it uses the corresponding ORM [servicer](???)
to handle the data access (e.g. `resource` object) and manipulation (e.g. its `update` method).
Wallaby also detects the authorization framework in use and
uses the [authorizer](???) to carry out the authorization check for the given resource.
Similarly, Wallaby uses [paginator](???) for `index` action to paginate the collection.

Although Wallaby currently only supports ActiveRecord together with CanCanCan and Pundit,
with the appropriate interfaces in place,
it can be easily extended to support other ORMs and authorization frameworks.
And before the desired ORM adapter is available, [Custom](???) mode will allow you to support any models.

## Decorator & Views

After controller action

## Admin Interface

## How Customization is Possible
