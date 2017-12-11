module Wallaby
  # Wallaby's application controller
  # It defaults to inherit from ::ApplicationController, which can be configured
  # via `Wallaby.configuration.base_controller`
  # It only contains the error handling logics
  class ApplicationController < configuration.base_controller
    helper ApplicationHelper

    ERROR_PATH = ERROR_LAYOUT = 'wallaby/error'.freeze

    # NOTE: we want to see the error blown up in development environment
    unless Rails.env.development?
      rescue_from NotFound, with: :not_found
      rescue_from ::ActionController::ParameterMissing, with: :bad_request
      rescue_from ::ActiveRecord::StatementInvalid, with: :unprocessable_entity
    end

    layout 'wallaby/application'

    # Not found page
    def not_found(exception = nil)
      error_rendering(exception, __callee__)
    end

    # Bad request page
    def bad_request(exception = nil)
      error_rendering(exception, __callee__)
    end

    # Unprocessable entity page
    def unprocessable_entity(exception = nil)
      error_rendering(exception, __callee__)
    end

    # Internal server error page
    def internal_server_error(exception = nil)
      error_rendering(exception, __callee__)
    end

    protected

    def configuration
      ::Wallaby.configuration
    end

    # capture exceptions and display the error using error layout and view
    def error_rendering(exception, symbol)
      @exception = exception
      @symbol = symbol
      @code = Rack::Utils::SYMBOL_TO_STATUS_CODE[@symbol].to_i

      Rails.logger.error @exception
      render ERROR_PATH, layout: ERROR_LAYOUT, status: symbol
    end
  end
end
