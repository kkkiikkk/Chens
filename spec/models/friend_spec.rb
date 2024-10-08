require 'rails_helper'

RSpec.describe Friend, type: :model do
  describe 'friend valid' do
    let(:new_user1) { FactoryBot.create(:user) }
    let(:new_user2) { FactoryBot.create(:user) }
    
    subject(:friend_test) { Friend.new(user1:, user2:, status:) }

    context 'friend is valid' do
      let(:user1) { new_user1 }
      let(:user2) { new_user2 }
      let(:status) { 'pending' }

      it 'returns true' do
        expect(friend_test.valid?).to be(true)
      end
    end

    context 'friend, user1 is invalid' do
      let(:user1) { nil }
      let(:user2) { new_user2 }
      let(:status) { 'pending' }

      it 'returns false' do
        expect(friend_test.valid?).to be(false)
      end
    end

    context 'friend, user2 is invalid' do
      let(:user1) { new_user1 }
      let(:user2) { nil }
      let(:status) { 'pending' }

      it 'returns false' do
        expect(friend_test.valid?).to be(false)
      end
    end

    context 'friend, status is invalid' do
      let(:user1) { new_user1 }
      let(:user2) { new_user2 }
      let(:status) { 'wrong status' }

      it 'returns false' do
        expect(friend_test.valid?).to be(false)
      end
    end

    context 'friend, self friend is invalid' do
      let(:user1) { new_user1 }
      let(:user2) { new_user1 }
      let(:status) { 'pending' }

      it 'returns false' do
        expect(friend_test.valid?).to be(false)
      end
    end
  end
end