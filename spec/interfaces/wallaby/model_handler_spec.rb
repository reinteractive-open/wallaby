require 'rails_helper'

describe Wallaby::ModelServiceProvider do
  subject { described_class.new AllPostgresType }

  describe 'collection' do
    it 'raises not implemented' do
      expect { subject.collection({}, nil) }.to raise_error Wallaby::NotImplemented
    end
  end

  describe 'new' do
    it 'raises not implemented' do
      expect { subject.new({}, nil) }.to raise_error Wallaby::NotImplemented
    end
  end

  describe 'find' do
    it 'raises not implemented' do
      expect { subject.find(1, {}, nil) }.to raise_error Wallaby::NotImplemented
    end
  end

  describe 'create' do
    it 'raises not implemented' do
      expect { subject.create(nil, {}, nil) }.to raise_error Wallaby::NotImplemented
    end
  end

  describe 'update' do
    it 'raises not implemented' do
      expect { subject.update(nil, {}, nil) }.to raise_error Wallaby::NotImplemented
    end
  end

  describe 'destroy' do
    it 'raises not implemented' do
      expect { subject.destroy(nil, {}, nil) }.to raise_error Wallaby::NotImplemented
    end
  end
end
