module Wallaby
  # Model Authorizer to provide authroization functions
  class AbstractModelAuthorizer
    class << self
      attr_writer :model_class
      attr_writer :provider

      def model_class
        return unless self < Wallaby.configuration.mapping.model_authorizer
        @model_class \
          || Map.model_authorizer_map(name.gsub('Authorizer', EMPTY_STRING))
      end

      def provider
        @provider ||=
          superclass.respond_to?(:provider) ? superclass.provider : nil
      end
    end

    delegate \
      :authorize, :authorize?, :authorize_field?, :accessible_by,
      :attributes_for, :permit_params, to: :@provider

      # @param context [ActionController::Base]
    def initialize(context, model_class)
      @model_class = model_class || self.class.model_class
      unless self.class.provider
        self.class.provider = guess_provider_by(context, model_class)
      end
      @provider = init_provider(self.class.provider, context)
    end

    protected

    def init_provider(provider, context)
      Wallaby::ActiveRecord::CancancanProvider.new context
    end

    def guess_provider_by(context, model_class)

    end
  end
end