require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: 'Top.Science',
    skip_general: true,
    max_length: 20,
    max_value: '814865cd-5a1d-4771-9306-4268f188fe9e',
    max_title: true
end
