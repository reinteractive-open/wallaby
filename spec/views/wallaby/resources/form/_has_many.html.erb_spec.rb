require 'rails_helper'

partial_name = 'form/has_many'
describe partial_name, :current_user do
  let(:partial)     { "wallaby/resources/#{partial_name}.html.erb" }
  let(:partial)     { 'wallaby/resources/form/has_many.html.erb' }
  let(:form)        { Wallaby::FormBuilder.new object.model_name.param_key, object, view, {} }
  let!(:object)     { Product.create! field_name => value }
  let(:field_name)  { metadata[:name] }
  let!(:value)      { [Order::Item.create!(id: 1)] }
  let(:metadata)    do
    {
      name: 'order_items', type: 'has_many', label: 'Order / Items',
      is_association: true, is_polymorphic: false, is_through: false, has_scope: false, foreign_key: 'order_item_ids', polymorphic_type: nil, polymorphic_list: [], class: Order::Item
    }
  end

  before { render partial, form: form, object: object, field_name: field_name, value: value, metadata: metadata }

  it 'renders the has_many form' do
    expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"product_order_item_ids\">Order / Items</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-4\">\n      <input name=\"product[order_item_ids][]\" type=\"hidden\" value=\"\" /><select class=\"form-control\" multiple=\"multiple\" name=\"product[order_item_ids][]\" id=\"product_order_item_ids\"><option selected=\"selected\" value=\"1\">1</option></select>\n    </div>\n    <p class=\"help-block\">\n      Press CTRL to select/deselect multiple items.\n      Or <a class=\"resource__create\" href=\"/admin/order::items/new\">Create Order / Item</a>\n    </p>\n  </div>\n  \n</div>\n"
    expect(rendered).to match 'selected="selected"'
  end

  context 'when value is nil' do
    let(:object) { Product.new }

    it 'renders the has_many form' do
      expect(rendered).to eq "<div class=\"form-group \">\n  <label for=\"product_order_item_ids\">Order / Items</label>\n  <div class=\"row\">\n    <div class=\"col-xs-6 col-sm-4\">\n      <input name=\"product[order_item_ids][]\" type=\"hidden\" value=\"\" /><select class=\"form-control\" multiple=\"multiple\" name=\"product[order_item_ids][]\" id=\"product_order_item_ids\"><option value=\"1\">1</option></select>\n    </div>\n    <p class=\"help-block\">\n      Press CTRL to select/deselect multiple items.\n      Or <a class=\"resource__create\" href=\"/admin/order::items/new\">Create Order / Item</a>\n    </p>\n  </div>\n  \n</div>\n"
      expect(rendered).not_to match 'selected="selected"'
    end
  end
end
