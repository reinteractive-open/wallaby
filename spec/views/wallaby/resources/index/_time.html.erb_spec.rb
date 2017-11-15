require 'rails_helper'

field_name = __FILE__[/_(.+)\.html\.erb_spec\.rb$/, 1]
type = __FILE__[%r{/([^/]+)/_}, 1]
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: Time.parse('Tue, 11 Feb 2014 23:59:59 +0000'),
    expected_value: '23:59:59' do

    context 'when value is a string' do
      let(:value) { 'Tue, 11 Feb 2014 23:59:59 +0000' }

      it 'renders the time' do
        expect(rendered).to include h(expected_value.to_s)
      end
    end
  end
end
