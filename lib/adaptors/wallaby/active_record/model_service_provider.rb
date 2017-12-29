module Wallaby
  class ActiveRecord
    # Model service provider
    # @see Wallaby::ModelServiceProvider
    class ModelServiceProvider < ::Wallaby::ModelServiceProvider
      # @see Wallaby::ModelServiceProvider#permit
      def permit(params)
        return {} if params[param_key].blank?
        # using fetch could avoid ActionController::ParameterMissing
        params.fetch(param_key, {}).permit permitted_fields
      end

      # @see Wallaby::ModelServiceProvider#collection
      def collection(params, authorizer)
        # NOTE: pagination free here
        # since somewhere might use it without pagination
        query = querier.search params
        query = query.order params[:sort] if params[:sort].present?
        query.accessible_by authorizer
      end

      # @see Wallaby::ModelServiceProvider#paginate
      def paginate(query, params)
        per = params[:per] || Wallaby.configuration.pagination.page_size
        query = query.page params[:page] if query.respond_to? :page
        query = query.per per if query.respond_to? :per
        query
      end

      # @see Wallaby::ModelServiceProvider#new
      def new(permitted_params, _authorizer)
        @model_class.new normalize permitted_params
      rescue ::ActiveModel::UnknownAttributeError
        @model_class.new
      end

      # @see Wallaby::ModelServiceProvider#find
      def find(id, permitted_params, _authorizer)
        resource = @model_class.find id
        resource.assign_attributes normalize permitted_params
        resource
      rescue ::ActiveRecord::RecordNotFound
        raise ResourceNotFound, id
      rescue ::ActiveModel::UnknownAttributeError
        resource
      end

      # @see Wallaby::ModelServiceProvider#create
      def create(resource_with_new_value, params, authorizer)
        save __callee__, resource_with_new_value, params, authorizer
      end

      # @see Wallaby::ModelServiceProvider#update
      def update(resource_with_new_value, params, authorizer)
        save __callee__, resource_with_new_value, params, authorizer
      end

      # @see Wallaby::ModelServiceProvider#destroy
      def destroy(resource, _params, _authorizer)
        resource.destroy
      end

      protected

      # Save the active record
      # @param action [String] `create`, `update`
      # @param resource [Object]
      # @param _params [ActionController::Parameters]
      # @param authorizer [Object]
      # @return resource itself
      def save(action, resource, _params, authorizer)
        ensure_attributes_for authorizer, action, resource
        resource.save if valid? resource
        resource
      rescue ::ActiveRecord::StatementInvalid => e
        resource.errors.add :base, e.message
        resource
      end

      # Normalize params
      # @param params [ActionController::Parameters]
      def normalize(params)
        normalizer.normalize params
      end

      # See if a resource is valid
      # @param resource [Object]
      # @return [Boolean]
      def valid?(resource)
        validator.valid? resource
      end

      # To make sure that the record can be updated with the values that are
      # allowed to.
      # @param authorizer [Object]
      # @param action [String]
      # @param resource [Object]
      def ensure_attributes_for(authorizer, action, resource)
        return if authorizer.blank?
        restricted_conditions = authorizer.attributes_for action, resource
        resource.assign_attributes restricted_conditions
      end

      # The params key
      def param_key
        @model_class.model_name.param_key
      end

      # The list of attributes to whitelist
      # @return [Array]
      def permitted_fields
        @permitted_fields ||=
          permitter.simple_field_names << permitter.compound_hashed_fields
      end

      # @see Wallaby::ModelServiceProvider::Permitter
      def permitter
        @permitter ||= Permitter.new @model_decorator
      end

      # @see Wallaby::ModelServiceProvider::Querier
      def querier
        @querier ||= Querier.new @model_decorator
      end

      # @see Wallaby::ModelServiceProvider::Normalizer
      def normalizer
        @normalizer ||= Normalizer.new @model_decorator
      end

      # @see Wallaby::ModelServiceProvider::Validator
      def validator
        @validator ||= Validator.new @model_decorator
      end
    end
  end
end
