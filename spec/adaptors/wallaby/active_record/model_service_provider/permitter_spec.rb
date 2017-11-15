require 'rails_helper'

describe Wallaby::ActiveRecord::ModelServiceProvider::Permitter do
  subject { described_class.new model_decorator }
  let(:model_decorator) { Wallaby::ActiveRecord::ModelDecorator.new AllPostgresType }

  describe 'model that has all postgres types' do
    describe '#simple_field_names' do
      it 'returns non-range fields' do
        expect(subject.simple_field_names).to eq %w(bigint bigserial binary bit bit_varying boolean box cidr circle citext color date datetime decimal email float hstore inet integer json jsonb line lseg ltree macaddr money password path polygon serial string text time tsvector uuid xml)
      end
    end

    describe '#compound_hashed_fields' do
      it 'returns range fields' do
        expect(subject.compound_hashed_fields).to eq 'daterange' => [], 'numrange' => [], 'tsrange' => [], 'tstzrange' => [], 'int4range' => [], 'int8range' => [], 'point' => []
      end
    end

    describe '#non_association_fields' do
      it 'returns non-association fields' do
        expect(subject.send(:non_association_fields).keys).to eq %w(id bigint bigserial binary bit bit_varying boolean box cidr circle citext color date daterange datetime decimal email float hstore inet int4range int8range integer json jsonb line lseg ltree macaddr money numrange password path point polygon serial string text time tsrange tstzrange tsvector uuid xml)
      end
    end

    describe '#non_range_fields' do
      it 'returns non-range fields' do
        expect(subject.send(:non_range_fields).keys).to eq %w(id bigint bigserial binary bit bit_varying boolean box cidr circle citext color date datetime decimal email float hstore inet integer json jsonb line lseg ltree macaddr money password path polygon serial string text time tsvector uuid xml)
      end
    end

    describe '#range_fields' do
      it 'returns range fields' do
        expect(subject.send(:range_fields).keys).to eq %w(daterange int4range int8range numrange point tsrange tstzrange)
      end
    end

    describe '#association_fields' do
      it 'returns association fields' do
        expect(subject.send(:association_fields).keys).to eq []
      end
    end

    describe '#many_association_fields' do
      it 'returns many-association fields' do
        expect(subject.send(:many_association_fields).keys).to eq []
      end
    end

    describe '#belongs_to_fields' do
      it 'returns belongs-to fields' do
        expect(subject.send(:belongs_to_fields).keys).to eq []
      end
    end
  end

  describe 'model that has associations' do
    let(:model_decorator) { Wallaby::ActiveRecord::ModelDecorator.new Product }
    describe '#simple_field_names' do
      it 'returns non-range fields' do
        expect(subject.simple_field_names).to eq %w(sku name description stock price featured available_to_date available_to_time published_at category_id)
      end
    end

    describe '#compound_hashed_fields' do
      it 'returns range fields' do
        expect(subject.compound_hashed_fields).to eq 'order_item_ids' => [], 'tag_ids' => []
      end
    end

    describe '#non_association_fields' do
      it 'returns non-association fields' do
        expect(subject.send(:non_association_fields).keys).to eq %w(id sku name description stock price featured available_to_date available_to_time published_at)
      end
    end

    describe '#non_range_fields' do
      it 'returns non-range fields' do
        expect(subject.send(:non_range_fields).keys).to eq %w(id sku name description stock price featured available_to_date available_to_time published_at)
      end
    end

    describe '#range_fields' do
      it 'returns range fields' do
        expect(subject.send(:range_fields).keys).to eq []
      end
    end

    describe '#association_fields' do
      it 'returns association fields' do
        expect(subject.send(:association_fields).keys).to eq %w(product_detail order_items category tags)
      end
    end

    describe '#many_association_fields' do
      it 'returns many-association fields' do
        expect(subject.send(:many_association_fields).keys).to eq %w(order_items tags)
      end
    end

    describe '#belongs_to_fields' do
      it 'returns belongs-to fields' do
        expect(subject.send(:belongs_to_fields).keys).to eq %w(category)
      end
    end
  end

  describe 'model that has polymorphic belongs-to' do
    let(:model_decorator) { Wallaby::ActiveRecord::ModelDecorator.new Picture }
    describe '#simple_field_names' do
      it 'returns non-range fields' do
        expect(subject.simple_field_names).to eq %w(name file imageable_id imageable_type)
      end
    end

    describe '#compound_hashed_fields' do
      it 'returns range fields' do
        expect(subject.compound_hashed_fields).to eq({})
      end
    end
  end
end
