module Wallaby
  module Resources
    module Index
      class ColorHtml < Cell
        def render(object:, field_name:, value:, metadata:) # rubocop:disable Lint/UnusedMethodArgument
          if value.nil?
            null
          else
            concat content_tag(:span, nil, style: "background-color: #{value};", class: 'color-square')
            content_tag(:span, value, class: 'text-uppercase')
          end
        end
      end
    end
  end
end