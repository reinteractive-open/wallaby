module Wallaby
  module Sorting
    # @private
    # Pass field_name to generate sort param for its next sort order
    # (e.g. from empty to `asc`, from `asc` to `desc`, from `desc` to empty)
    class NextBuilder
      ASC = 'asc'.freeze
      DESC = 'desc'.freeze

      # @param params [ActionController::Parameters]
      # @param hash [Hash, nil] sorting hash
      def initialize(params, hash = nil)
        @params = params
        @hash = hash || HashBuilder.build(params[:sort])
      end

      # Update the `sort` parameter.
      # @example for param `{sort: 'name asc'}`, it will update the parameters
      #   to `{sort: 'name desc'}`
      # @param field_name [String] field name
      # @return [ActionController::Parameters]
      #   updated parameters that update the sort order for given field
      def next_params(field_name)
        params = clean_params
        update params, :sort, complete_sorting_str_with(field_name)
        params
      end

      protected

      # @return [ActionController::Parameters] whitelisted parameters
      def clean_params
        @params.except :resources, :controller, :action
      end

      # @param field_name [String] field name
      # @return [String] a sort order string, e.g. `'name asc'`
      def complete_sorting_str_with(field_name)
        hash = @hash.except field_name
        current_sort = @hash[field_name]

        update hash, field_name, next_value_for(current_sort)
        rebuild_str_from hash
      end

      # @param hash [Hash] sort order hash
      # @return [String] a sort order string, e.g. `'name asc'`
      def rebuild_str_from(hash)
        hash.each_with_object('') do |(name, sort), str|
          str << (str == EMPTY_STRING ? str : COMMA)
          str << name << SPACE << sort
        end
      end

      # @param current [String, nil] current sort order
      # @return [String, nil] next state of sort order
      def next_value_for(current)
        case current
        when ASC then DESC
        when DESC then nil
        else ASC
        end
      end

      # Update the value for given key. Remove the key if value is blank
      # @param hash [Hash] sort order hash
      # @param key [String] key name
      # @param value [Object, nil] value
      def update(hash, key, value)
        return hash.delete key if value.blank?
        hash[key] = value
      end
    end
  end
end
