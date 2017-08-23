require 'rails_helper'

partial_name = 'index/has_many'
describe partial_name, :current_user do
  let(:partial) { "wallaby/resources/#{partial_name}.html.erb" }
  let(:page) { Nokogiri::HTML rendered }
  let(:metadata) { Hash label: 'Products' }
  let(:value) do
    [
      Product.new(id: 1, name: 'Hiking shoes'),
      Product.new(id: 2, name: 'Hiking pole'),
      Product.new(id: 3, name: 'Hiking jacket')
    ]
  end

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the has_many' do
    expect(page.at_css('.modaler > a').content).to eq '1 more'
    expect(page.at_css('.modaler__title').inner_html).to eq escape(metadata[:label])
    expect(page.css('.modaler__body a').length).to eq 3

    expect(page.at_css('.modaler__body').inner_html).to match view.show_link(value[0])
    expect(page.at_css('.modaler__body').inner_html).to match view.show_link(value[1])
    expect(page.at_css('.modaler__body').inner_html).to match view.show_link(value[2])

    expect(page.css('.modaler__body a')[0].content).to eq value[0].name
    expect(page.css('.modaler__body a')[1].content).to eq value[1].name
    expect(page.css('.modaler__body a')[2].content).to eq value[2].name
  end

  context 'when value size is no more than 2' do
    let(:value) do
      [
        Product.new(id: 1, name: 'Hiking shoes'),
        Product.new(id: 2, name: 'Hiking pole')
      ]
    end

    it 'renders the has_many' do
      expect(rendered).to include view.show_link(value.first)
      expect(rendered).to include view.show_link(value.second)
    end
  end

  context 'when value is []' do
    let(:value) { [] }

    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
