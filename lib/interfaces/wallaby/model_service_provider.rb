module Wallaby
  # Model service provider interface
  class ModelServiceProvider
    def initialize(model_class, model_decorator = nil)
      raise ::ArgumentError, 'model class required' unless model_class
      @model_class = model_class
      @model_decorator = model_decorator || Map.model_decorator_map(model_class)
    end

    def permit(_params)
      raise NotImplemented
    end

    def collection(_params, _authorizer)
      raise NotImplemented
    end

    def paginate(_query, _params)
      raise NotImplemented
    end

    def new(_params, _authorizer)
      raise NotImplemented
    end

    def find(_id, _params, _authorizer)
      raise NotImplemented
    end

    def create(_resource, _params, _authorizer)
      raise NotImplemented
    end

    def update(_resource, _params, _authorizer)
      raise NotImplemented
    end

    def destroy(_resource, _params, _authorizer)
      raise NotImplemented
    end
  end
end
