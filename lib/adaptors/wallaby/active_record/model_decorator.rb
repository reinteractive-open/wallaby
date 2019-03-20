module Wallaby
  class ActiveRecord
    # Modal decorator for ActiveRecord
    class ModelDecorator < ::Wallaby::ModelDecorator
      # Data types to exclude for index page
      INDEX_EXCLUSIVE_DATA_TYPES =
        (['', 'medium', 'long'] * 2)
        .zip(%w(blob text) * 3).map(&:join)
        .concat(%w(binary citext hstore json jsonb tsvector xml)).freeze

      # Class to exclude for show page
      SHOW_EXCLUSIVE_CLASS_NAMES = %w(ActiveStorage::Attachment ActiveStorage::Blob).freeze

      # Data types to exclude for form page
      FORM_EXCLUSIVE_DATA_TYPES = %w(created_at updated_at).freeze

      # Origin metadata directly coming from ActiveRecord.
      # It needs to be frozen so that we can keep the metadata integrity
      # @return [Hash] metadata
      #   example:
      #     {
      #       # general field
      #       id: { name: 'id', type: 'integer', label: 'Id' },
      #       # association field
      #       category: {
      #         'name' => 'category',
      #         'type' => 'belongs_to',
      #         'label' => 'Category',
      #         'is_association' => true,
      #         'is_through' => false,
      #         'has_scope' => false,
      #         'foreign_key' => 'category_id',
      #         'class' => Category
      #       }
      #     }
      def fields
        @fields ||= ::ActiveSupport::HashWithIndifferentAccess.new.tap do |hash|
          # NOTE: There is a chance that people create ActiveRecord class
          # before they do the migration, so initialising the fields will raise
          # all kinds of error. Therefore, we need to check the table existence
          if @model_class.table_exists?
            hash.merge! general_fields
            hash.merge! association_fields
            hash.except!(*foreign_keys_from_associations)
          end
        end.freeze
      end

      # A copy of `fields` for index page
      # @return [Hash] metadata
      def index_fields
        @index_fields ||= Utils.clone fields
      end

      # A copy of `fields` for show page
      # @return [Hash] metadata
      def show_fields
        @show_fields  ||= Utils.clone fields
      end

      # A copy of `fields` for form (new/edit) page
      # @return [Hash] metadata
      def form_fields
        @form_fields  ||= Utils.clone fields
      end

      # @return [Array<String>] a list of field names for index page.
      #   By default, only native SQL types will be included.
      def index_field_names
        @index_field_names ||= begin
          index_fields.reject do |_field_name, metadata|
            metadata[:is_association] \
              || INDEX_EXCLUSIVE_DATA_TYPES.include?(metadata[:type])
          end.keys
        end
      end

      # @return [Array<String>] a list of field names for show page.
      #   By default, `ActiveStorage` fields will be excluded.
      def show_field_names
        @show_field_names ||= begin
          show_fields.reject do |_field_name, metadata|
            SHOW_EXCLUSIVE_CLASS_NAMES.include? metadata[:class].try(:name)
          end.keys
        end
      end

      # @return [Array<String>] a list of field names for form (new/edit) page
      #   By default, complex fields will be excluded.
      def form_field_names
        @form_field_names ||= begin
          form_fields.reject do |field_name, metadata|
            field_name == primary_key \
              || FORM_EXCLUSIVE_DATA_TYPES.include?(field_name) \
              || metadata[:has_scope] || metadata[:is_through]
          end.keys
        end
      end

      # @return [ActiveModel::Errors] errors for resource
      def form_active_errors(resource)
        resource.errors
      end

      # @return [String] primary key for the resource
      def primary_key
        @model_class.primary_key
      end

      # To guess the title for resource.
      #
      # It will go through the fields and try to find out the one that looks
      # like a name or text to represent this resource. Otherwise, it will fall
      # back to primary key.
      #
      # @param resource [Object]
      # @return [String] the title of given resource
      def guess_title(resource)
        resource.public_send title_field_finder.find
      end

      protected

      # @see Wallaby::ModelDecorator::FieldsBuilder
      def field_builder
        @field_builder ||= FieldsBuilder.new @model_class
      end

      # @see Wallaby::ModelDecorator::TitleFieldFinder
      def title_field_finder
        @title_field_finder ||=
          TitleFieldFinder.new @model_class, general_fields
      end

      delegate :general_fields, :association_fields, to: :field_builder

      # Find out all the foreign keys for a list of fields
      # @param fields [Hash] metadata of fields
      # @return [Array<String>] a list of foreign keys
      def foreign_keys_from_associations(fields = association_fields)
        fields.each_with_object([]) do |(_field_name, metadata), keys|
          keys << metadata[:foreign_key] if metadata[:foreign_key]
          keys << metadata[:polymorphic_type] if metadata[:polymorphic_type]
          keys
        end
      end
    end
  end
end
