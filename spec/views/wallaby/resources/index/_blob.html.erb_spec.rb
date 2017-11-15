require 'rails_helper'

field_name = 'blob'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: '010111',
    model_class: AllMysqlType,
    skip_general: true do

    it 'renders the blob' do
      expect(rendered).to include view.muted('blob')
    end
  end
end