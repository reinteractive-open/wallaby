module Wallaby
  module Sorting
    # Turn a string `'name asc,id desc'` into sort hash
    class HashBuilder
      SORT_REGEX = /(([^\s,]+)\s+(asc|desc))\s*,?\s*/i

      def self.build(sort_string)
        ::ActiveSupport::HashWithIndifferentAccess.new.tap do |hash|
          (sort_string || EMPTY_STRING).scan SORT_REGEX do |_, key, order|
            hash[key] = order
          end
        end
      end
    end
  end
end
