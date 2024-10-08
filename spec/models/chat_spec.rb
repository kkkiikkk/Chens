require 'rails_helper'

RSpec.describe Chat, type: :model do
  describe 'chat valid' do
    let(:new_user) { FactoryBot.create(:user) }
    let(:workspace_test) { FactoryBot.create(:workspace, user: new_user) }
        
    subject(:chat_test) { Chat.new(name:, chat_type:, chat_status:, workspace:) }
    
    context 'when chat is valid' do
      let(:name) { 'test chat' }
      let(:chat_type) { 'public' }
      let(:chat_status) { 'active' }
      let(:workspace) { workspace_test }

      it 'returns true' do
        expect(chat_test.valid?).to be(true)
      end
    end

    context 'when chat workspace is invalid' do
      let(:name) { 'test chat' }
      let(:chat_type) { 'public' }
      let(:chat_status) { 'active' }
      let(:workspace) { nil }

      it 'returns true' do
        expect(chat_test.valid?).to be(false)
      end
    end

    context 'when chat status is invalid' do
      let(:name) { 'test chat' }
      let(:chat_type) { 'public' }
      let(:workspace) { workspace_test }
      let(:chat_status) { 'wrong status' }

      it 'returns true' do
        expect(chat_test.valid?).to be(false)
      end
    end

    context 'when chat type is invalid' do
      let(:name) { 'test chat' }
      let(:chat_type) { 'wrong chat type' }
      let(:workspace) { workspace_test }
      let(:chat_status) { 'active' }

      it 'returns true' do
        expect(chat_test.valid?).to be(false)
      end
    end

    context 'when chat name is invalid' do
      let(:name) { nil }
      let(:chat_type) { 'public' }
      let(:workspace) { workspace_test }
      let(:chat_status) { 'active' }

      it 'returns true' do
        expect(chat_test.valid?).to be(false)
      end
    end

    context 'when chat name is empty for p2p chat' do
      let(:name) { nil }
      let(:chat_type) { 'p2p' }
      let(:workspace) { workspace_test }
      let(:chat_status) { 'active' }

      it 'returns true' do
        expect(chat_test.valid?).to be(true)
      end
    end
  end
end