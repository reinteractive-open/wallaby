require 'rails_helper'
require 'wallaby/active_record'

describe Wallaby::ResourceDecorator do
  describe 'class methods' do
    describe '.model_class' do
      it 'returns nil' do
        expect(described_class.model_class).to be_nil
      end
    end

    describe '.model_decorator' do
      it 'returns nil' do
        expect(described_class.model_class).to be_nil
      end
    end

    [ '', 'index_', 'show_', 'form_' ].each do |prefix|
      title = prefix.gsub '_', ''
      describe "for #{ title }" do
        describe ".#{ prefix }fields" do
          it 'returns nil' do
            expect(described_class.send "#{ prefix }fields").to be_nil
          end
        end

        describe ".#{ prefix }field_names" do
          it 'returns nil' do
            expect(described_class.send "#{ prefix }field_names").to be_nil
          end
        end

        describe ".#{ prefix }metadata_of" do
          it 'returns nil' do
            expect(described_class.send "#{ prefix }metadata_of").to be_nil
          end
        end

        describe ".#{ prefix }label_of" do
          it 'returns nil' do
            expect(described_class.send "#{ prefix }label_of", '').to be_nil
          end
        end

        describe ".#{ prefix }type_of" do
          it 'returns nil' do
            expect(described_class.send "#{ prefix }type_of", '').to be_nil
          end
        end
      end
    end
  end

  describe 'instance methods' do
    let(:subject) { Wallaby::ResourceDecorator.new resource }
    let(:resource) { double 'Resource', class: post_model }
    let(:post_model) { double 'Post', name: 'Post' }

    before do
      allow(post_model).to receive(:columns).and_return([
        double('Title', name: 'title', type: :string),
        double('Published at', name: 'published_at', type: :datetime),
        double('Updated at', name: 'updated_at', type: :datetime),
        double('ID', name: 'id', type: :integer)
      ])

      allow(post_model).to receive(:primary_key).and_return('id')

      allow(post_model).to receive(:human_attribute_name).and_return('fake title')

      allow(post_model).to receive(:reflect_on_all_associations).and_return([])
    end

    describe '#model_class' do
      it 'returns model class' do
        expect(subject.model_class).to eq post_model
      end
    end

    describe '.model_decorator' do
      it 'returns model class' do
        expect(subject.model_decorator).not_to be_nil
      end
    end

    [ '', 'index_', 'show_', 'form_' ].each do |prefix|
      title = prefix.gsub '_', ''
      describe "for #{ title }" do
        describe "##{ prefix }fields" do
          it 'returns fields hash' do
            expect(subject.send "#{ prefix }fields").to eq({
              'title'         => { type: :string, label: 'fake title' },
              'published_at'  => { type: :datetime, label: 'fake title' },
              'updated_at'    => { type: :datetime, label: 'fake title' },
              'id'            => { type: :integer, label: 'fake title' }
            })
          end

          it 'is not allowed to modify the fields array' do
            expect{ subject.send("#{ prefix }fields").delete 'title' }.to raise_error "can't modify frozen Hash"
          end
        end

        describe "##{ prefix }field_names" do
          it 'returns field names array' do
            if prefix == 'form_'
              expect(subject.send "#{ prefix }field_names").to eq(["title", "published_at"])
            else
              expect(subject.send "#{ prefix }field_names").to eq(["id", "title", "published_at", "updated_at"])
            end
          end

          it 'is not allowed to modify the field names array' do
            expect{ subject.send("#{ prefix }field_names").delete 'title' }.to raise_error "can't modify frozen Array"
          end
        end

        describe "##{ prefix }metadata_of" do
          it 'returns metadata' do
            expect(subject.send "#{ prefix }metadata_of", 'id').to eq({
              type:   :integer,
              label:  'fake title'
            })
          end
        end

        describe "##{ prefix }label_of" do
          it 'returns label' do
            expect(subject.send "#{ prefix }label_of", 'id').to eq 'fake title'
          end
        end

        describe "##{ prefix }type_of" do
          it 'returns type' do
            expect(subject.send "#{ prefix }type_of", 'id').to eq :integer
          end
        end
      end
    end
  end

  context 'subclasses' do
    let(:klass) do
      class AbstractPostDecorator < Wallaby::ResourceDecorator; end
      AbstractPostDecorator
    end
    let(:post_model) do
      class AbstractPost
        def self.columns; end
        def self.primary_key; end
        def self.human_attribute_name field; end
        def self.reflect_on_all_associations; end
      end
      AbstractPost
    end

    before do
      allow(klass).to receive(:model_class).and_return(post_model)
      allow(post_model).to receive(:columns).and_return([
        double('Title', name: 'title', type: :string),
        double('Published at', name: 'published_at', type: :datetime),
        double('Updated at', name: 'updated_at', type: :datetime),
        double('ID', name: 'id', type: :integer)
      ])

      allow(post_model).to receive(:primary_key).and_return('id')

      allow(post_model).to receive(:human_attribute_name).and_return('fake title')

      allow(post_model).to receive(:reflect_on_all_associations).and_return([])
    end

    describe 'class methods' do
      describe '.model_class' do
        it 'returns model class' do
          expect(klass.model_class).to eq post_model
        end
      end

      describe '.model_decorator' do
        it 'returns model class' do
          expect(klass.model_decorator).not_to be_nil
        end
      end

      [ '', 'index_', 'show_', 'form_' ].each do |prefix|
        title = prefix.gsub '_', ''
        describe "for #{ title }" do
          describe ".#{ prefix }fields" do
            after do
              klass.model_decorator.instance_variable_set "@#{ prefix }fields", nil
            end

            it 'returns fields hash' do
              expect(klass.send "#{ prefix }fields").to eq({
                'title'         => { type: :string, label: 'fake title' },
                'published_at'  => { type: :datetime, label: 'fake title' },
                'updated_at'    => { type: :datetime, label: 'fake title' },
                'id'            => { type: :integer, label: 'fake title' }
              })
            end

            it 'caches the fields hash' do
              expect{ klass.send("#{ prefix }fields").delete 'title' }.to change{ klass.send "#{ prefix }fields" }.from({
                'title'         => { type: :string, label: 'fake title' },
                'published_at'  => { type: :datetime, label: 'fake title' },
                'updated_at'    => { type: :datetime, label: 'fake title' },
                'id'            => { type: :integer, label: 'fake title' }
              }).to({
                'published_at'  => { type: :datetime, label: 'fake title' },
                'updated_at'    => { type: :datetime, label: 'fake title' },
                'id'            => { type: :integer, label: 'fake title' }
              })
            end
          end

          describe ".#{ prefix }field_names" do
            after do
              klass.model_decorator.instance_variable_set "@#{ prefix }field_names", nil
            end

            it 'returns field names array' do
              if prefix == 'form_'
                expect(klass.send "#{ prefix }field_names").to eq(["title", "published_at"])
              else
                expect(klass.send "#{ prefix }field_names").to eq(["id", "title", "published_at", "updated_at"])
              end
            end

            it 'caches the field names array' do
              if prefix == 'form_'
                expect{ klass.send("#{ prefix }field_names").delete 'title' }.to change{ klass.send "#{ prefix }field_names" }.from(["title", "published_at"]).to(["published_at"])
              else
                expect{ klass.send("#{ prefix }field_names").delete 'title' }.to change{ klass.send "#{ prefix }field_names" }.from(["id", "title", "published_at", "updated_at"]).to(["id", "published_at", "updated_at"])
              end
            end
          end

          describe ".#{ prefix }metadata_of" do
            it 'returns metadata' do
              expect(klass.send "#{ prefix }metadata_of", 'id').to eq({
                type:   :integer,
                label:  'fake title'
              })
            end
          end

          describe ".#{ prefix }label_of" do
            it 'returns label' do
              expect(klass.send "#{ prefix }label_of", 'id').to eq 'fake title'
            end
          end

          describe ".#{ prefix }type_of" do
            it 'returns type' do
              expect(klass.send "#{ prefix }type_of", 'id').to eq :integer
            end
          end
        end
      end
    end
  end
end