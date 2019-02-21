module Wallaby
  module Resources
    module Index
      class BlobHtml < Cell
        def render(object:, field_name:, value:, metadata:) # rubocop:disable Lint/UnusedMethodArgument
          value ? muted('blob') : null
        end
      end
    end
  end
end