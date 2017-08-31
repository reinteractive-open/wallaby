require 'rails_helper'

partial_name = 'show/path'
describe partial_name do
  let(:partial) { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value) { resource.path }
  let(:resource) { AllPostgresType.new path: '((1,2),(3,4))' }
  let(:metadata) { { label: 'Path' } }

  before { render partial, value: value, metadata: metadata }

  it 'renders the path' do
    expect(rendered).to include "<code>#{value}</code>"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
