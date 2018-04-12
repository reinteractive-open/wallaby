require 'rails_helper'

describe Wallaby::Configuration::Mapping do
  it_behaves_like \
    'has attribute with default value',
    :resources_controller, Wallaby::ResourcesController

  context 'when admin application controller exists' do
    context 'it doesnt inherit form resources controller' do
      before { stub_const('Admin::ApplicationController', Class.new) }
      it_behaves_like \
        'has attribute with default value',
        :resources_controller, Wallaby::ResourcesController
    end

    context 'it inherits form resources controller' do
      before { stub_const('Admin::ApplicationController', Class.new(Wallaby::ResourcesController)) }
      it_behaves_like \
        'has attribute with default value',
        :resources_controller, -> { Admin::ApplicationController }
    end
  end

  it_behaves_like \
    'has attribute with default value',
    :resource_decorator, Wallaby::ResourceDecorator

  context 'when admin application decorator exists' do
    context 'it doesnt inherit form resource decorator' do
      before { stub_const('Admin::ApplicationDecorator', Class.new) }
      it_behaves_like \
        'has attribute with default value',
        :resource_decorator, Wallaby::ResourceDecorator
    end

    context 'it inherits form resource decorator' do
      before { stub_const('Admin::ApplicationDecorator', Class.new(Wallaby::ResourceDecorator)) }
      it_behaves_like \
        'has attribute with default value',
        :resource_decorator, -> { Admin::ApplicationDecorator }
    end
  end

  it_behaves_like \
    'has attribute with default value',
    :resource_paginator, Wallaby::ResourcePaginator

  context 'when admin application paginator exists' do
    context 'it doesnt inherit form resource paginator' do
      before { stub_const('Admin::ApplicationPaginator', Class.new) }
      it_behaves_like \
        'has attribute with default value',
        :resource_paginator, Wallaby::ResourcePaginator
    end

    context 'it inherits form resource paginator' do
      before { stub_const('Admin::ApplicationPaginator', Class.new(Wallaby::ResourcePaginator)) }
      it_behaves_like \
        'has attribute with default value',
        :resource_paginator, -> { Admin::ApplicationPaginator }
    end
  end

  it_behaves_like \
    'has attribute with default value',
    :model_servicer, Wallaby::ModelServicer

  context 'when admin application servicer exists' do
    context 'it doesnt inherit form model servicer' do
      before { stub_const('Admin::ApplicationServicer', Class.new) }
      it_behaves_like \
        'has attribute with default value',
        :model_servicer, Wallaby::ModelServicer
    end

    context 'it inherits form model servicer' do
      before { stub_const('Admin::ApplicationServicer', Class.new(Wallaby::ModelServicer)) }
      it_behaves_like \
        'has attribute with default value',
        :model_servicer, -> { Admin::ApplicationServicer }
    end
  end
end
