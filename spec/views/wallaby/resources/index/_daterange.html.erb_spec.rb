require 'rails_helper'

field_name = __FILE__[/_(.+)\.html\.erb_spec\.rb$/, 1]
type = __FILE__[%r{/([^/]+)/_}, 1]
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: Date.new(2014, 2, 11)..Date.new(2014, 2, 12),
    skip_general: true do

    it 'renders the daterange' do
      expect(rendered).to include '<span class="from">Feb 11</span>'
      expect(rendered).to include '<span class="to">Feb 12</span>'
      expect(rendered).to include 'title="2014-02-11 ... 2014-02-12"'
    end
  end
end
