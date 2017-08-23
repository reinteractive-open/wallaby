require 'rails_helper'

partial_name = 'index/json'
describe partial_name do
  let(:partial) { "wallaby/resources/#{partial_name}.html.erb" }
  let(:page) { Nokogiri::HTML rendered }
  let(:metadata) { { label: partial_name } }
  let(:value) do
    {
      'kind' => 'user_renamed',
      'change' => %w(jack john)
    }
  end

  before do
    render partial, value: value, metadata: metadata
  end

  it 'renders the json' do
    expect(page.at_css('code').inner_html).to eq '{"kind":"user_ren...'
    expect(page.at_css('.modaler__title').inner_html).to eq escape(metadata[:label])
    expect(page.at_css('.modaler__body').inner_html).to eq "<pre>#{escape(value.to_json)}</pre>"
  end

  context 'when value is less than 20 characters' do
    let(:value) { { 'a' => 1 } }
    it 'renders the json' do
      expect(rendered).to include h(value.to_json)
    end
  end

  context 'when max is set to 50' do
    let(:metadata) { Hash max: 50 }
    it 'renders the json' do
      expect(rendered).to include h(value.to_json)
    end
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
