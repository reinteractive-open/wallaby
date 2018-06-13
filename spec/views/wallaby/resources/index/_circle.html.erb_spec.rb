require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: '<(1,2),5>',
    skip_general: true,
    code_value: true,
    max_length: 20,
    max_value: '<(1.0000008,2.00000008),5.00000008>',
    max_title: true
end
