require 'rails_helper'

describe 'URL helpers', type: :helper do
  describe 'action_view/routing_url_for' do
    it 'returns url' do
      super_method = helper.method(:url_for).super_method
      expect(super_method.call(parameters!(controller: 'application', action: 'index'))).to eq '/test/purpose'
    end
  end

  describe 'wallaby_engine.resources_path helper' do
    it 'returns url' do
      expect(helper.wallaby_engine.resources_path(action: 'index', resources: 'products')).to eq '/admin/products'

      version_specific = {
        5 => {
          0 => {
            0 => '/admin/%23%3CActionController::Parameters'
          }
        }
      }
      expected = tiny version_specific, '/admin/action=index&resources=products'
      expect(helper.wallaby_engine.resources_path(parameters!(action: 'index', resources: 'products'))).to match expected
    end
  end
end
