require 'rails_helper'

field_name = __FILE__[/_(.+)\.html\.erb_spec\.rb$/, 1]
type = __FILE__[%r{/([^/]+)/_}, 1]
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: Time.new(2014, 2, 11, 23, 59, 59, '+00:00'),
    type: 'time',
    expected_value: '2014-02-11 23:59:59 +0000'
end
