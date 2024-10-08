require 'rails_helper'

RSpec.describe UserSetting, type: :model do
  describe 'user setting valid' do
    let(:new_user) { FactoryBot.create(:user) }

    subject(:user_setting_test) { UserSetting.new(user:, notifications:) }

    context 'user setting is valid' do
      let(:user) { new_user }
      let(:notifications) { true }

      it 'returns true' do
        expect(user_setting_test.valid?).to be(true)
      end
    end

    context 'user setting, user is invalid' do
      let(:user) { nil }
      let(:notifications) { true }
      
      it 'returns false' do
        expect(user_setting_test.valid?).to be(false)
      end
    end

    context 'user setting, notifications is invalid' do
      let(:user) { new_user }
      let(:notifications) { nil }
      
      it 'returns false' do
        expect(user_setting_test.valid?).to be(false)
      end
    end
  end
end