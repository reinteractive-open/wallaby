require 'rails_helper'

describe Wallaby::ResourcesHelper, :current_user do
  describe '#model_decorator' do
    it 'returns a model decorator' do
      expect(helper.model_decorator(AllPostgresType)).to be_a Wallaby::ActiveRecord::ModelDecorator
    end

    context 'when model dose not exist' do
      it 'returns a model decorator' do
        expect(helper.model_decorator(Array)).to be_blank
      end
    end
  end

  describe '#model_servicer' do
    it 'returns a model decorator' do
      expect(helper.model_servicer(AllPostgresType)).to be_a Wallaby::ModelServicer
    end
  end

  describe '#decorate' do
    context 'single object' do
      it 'returns a decorator' do
        resource = Product.new
        expect(helper.decorate(resource)).to be_a Wallaby::ResourceDecorator
      end

      context 'when decorated' do
        it 'returns the same decorated' do
          resource = Product.new
          decorated = helper.decorate(resource)
          expect(helper.decorate(decorated)).to be_a Wallaby::ResourceDecorator
          expect(helper.decorate(decorated)).to eq decorated
        end
      end
    end

    context 'when resources is enumerable' do
      before { AllPostgresType.create string: 'string' }
      let(:resources) { AllPostgresType.where(nil) }

      it 'returns decorators' do
        expect(helper.decorate(resources)).to be_an Array
        expect(helper.decorate(resources)).to all be_a Wallaby::ResourceDecorator
      end

      context 'when decorated' do
        it 'returns the same decorated' do
          decorated = helper.decorate(resources)
          expect(helper.decorate(decorated)).to all be_a Wallaby::ResourceDecorator
          expect(helper.decorate(decorated)).to eq decorated
        end
      end
    end
  end

  describe '#extract' do
    let(:resource) { Product.new }

    it 'returns origin resource' do
      new_resource = Wallaby::ResourceDecorator.new resource
      expect(helper.extract(new_resource)).to eq resource
    end

    context 'when resource is origin' do
      it 'returns itself' do
        expect(helper.extract(resource)).to eq resource
      end
    end
  end

  describe '#default_metadata' do
    it 'returns the metadata configuration' do
      expect(helper.default_metadata).to be_a Wallaby::Configuration::Metadata
    end
  end

  describe '#type_partial_render', prefixes: ['wallaby/resources/index'] do
    let(:object) { Wallaby::ResourceDecorator.new Product.new(name: 'product_name') }

    it 'checks the arguments' do
      expect { helper.type_partial_render }.to raise_error ArgumentError
      expect { helper.type_partial_render 'integer', field_name: 'name' }.to raise_error ArgumentError
      expect { helper.type_partial_render 'integer', field_name: 'name', object: Product.new }.to raise_error ArgumentError

      expect { helper.type_partial_render 'integer', field_name: 'name', object: object }.not_to raise_error
    end

    describe 'partials' do
      it 'renders a type partial' do
        expect(helper.type_partial_render('integer', object: object, field_name: 'name')).to eq "0\n"
      end

      context 'when partial does not exists' do
        it 'renders string partial' do
          expect(helper.type_partial_render('unknown', object: object, field_name: 'name')).to eq "    product_name\n"
        end
      end

      context 'for custom show fields' do
        let(:decorator_class) do
          stub_const 'FormProductDecorator', (Class.new(Wallaby::ResourceDecorator) do
            def self.model_class; Product; end

            show_fields[:custom] = { type: 'string', name: 'Custom Field' }

            def custom
              name
            end
          end)
        end

        let(:object) do
          decorator_class.new Product.new(name: 'custom_value')
        end

        it 'renders the custom field' do
          expect(helper.type_partial_render('string', object: object, field_name: 'custom')).to eq "    custom_value\n"
          expect(helper.type_partial_render('string', { object: object, field_name: 'custom' }, :show_metadata_of)).to eq "    custom_value\n"
        end
      end

      context 'for custom index fields' do
        let(:decorator_class) do
          stub_const 'FormProductDecorator', (Class.new(Wallaby::ResourceDecorator) do
            def self.model_class; Product; end

            index_fields[:custom] = { type: 'string', name: 'Custom Field' }

            def custom
              name
            end
          end)
        end

        let(:object) do
          decorator_class.new Product.new(name: 'custom_value')
        end

        it 'renders the custom field' do
          expect(helper.type_partial_render('string', { object: object, field_name: 'custom' }, :index_metadata_of)).to eq "    custom_value\n"
          expect(helper.index_type_partial_render('string', object: object, field_name: 'custom')).to eq "    custom_value\n"
        end
      end
    end
  end

  describe '#show_title' do
    it 'returns a title for decorated resources' do
      resource = Product.new name: 'example'
      decorated = helper.decorate resource
      expect(helper.show_title(decorated)).to eq 'Product: example'
    end

    context 'when it is not decorated' do
      it 'raises error' do
        resource = Product.new name: 'example'
        expect { helper.show_title resource }.to raise_error ArgumentError
      end
    end
  end
end
