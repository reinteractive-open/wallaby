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
      if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR == 0 && Rails::VERSION::TINY == 0
        expect(helper.wallaby_engine.resources_path(parameters!(action: 'index', resources: 'products'))).to match '/admin/%23%3CActionController::Parameters'
      else
        expect(helper.wallaby_engine.resources_path(parameters!(action: 'index', resources: 'products'))).to match '/admin/action=index&resources=products'
      end
    end
  end
end
