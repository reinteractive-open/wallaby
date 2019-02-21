module Wallaby
  module Resources
    module Index
      class UnsignedFloatHtml < Cell
        def render(object:, field_name:, value:, metadata:) # rubocop:disable Lint/UnusedMethodArgument
          value.try(:to_f) || null
        end
      end
    end
  end
end