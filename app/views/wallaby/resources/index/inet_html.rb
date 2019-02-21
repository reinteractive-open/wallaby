module Wallaby
  module Resources
    module Index
      class InetHtml < Cell
        def render(object:, field_name:, value:, metadata:) # rubocop:disable Lint/UnusedMethodArgument
          if value.nil?
            null
          else
            concat content_tag(:code, value)
            link_to(
              fa_icon('external-link-square', 'external-link-square-alt'), "http://ip-api.com/##{value}",
              target: :_blank, class: 'text-info'
            )
          end
        end
      end
    end
  end
end