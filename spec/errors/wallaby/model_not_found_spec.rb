require 'rails_helper'

describe Wallaby::ModelNotFound do
  subject { described_class.new AllPostgresType }

  describe '#message' do
    it 'returns the message' do
      expect(subject.message).to eq 'Model AllPostgresType can not be found.'
    end
  end
end
