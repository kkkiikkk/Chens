require 'rails_helper'

RSpec.describe Chat, type: :model do
  describe 'chat member valid' do
    let(:workspace_owner) { FactoryBot.create(:user) }
    let(:workspace_test) { FactoryBot.create(:workspace, user: workspace_owner) }
    let(:chat_test) { FactoryBot.create(:chat, workspace: workspace_test) }
    
    subject(:chat_member) { ChatMember.new(chat:, user:, role:) }

    context 'when chat member is valid' do
      let(:user) { workspace_owner }
      let(:chat) { chat_test }
      let(:role) { 'owner' }
      
      it 'returns true' do
        expect(chat_member.valid?).to be(true)
      end
    end

    context 'when chat member role is invalid' do
      let(:user) { workspace_owner }
      let(:chat) { chat_test }
      let(:role) { 'wrong role' }

      it 'returns false' do
        expect(chat_member.valid?).to be(false)
      end
    end

    context 'when chat member chat is invalid' do
      let(:user) { workspace_owner }
      let(:chat) { nil }
      let(:role) { 'owner' }
      
      it 'returns false' do
        expect(chat_member.valid?).to be(false)
      end
    end

    context 'when chat member user is invalid' do
      let(:user) { nil }
      let(:chat) { chat_test }
      let(:role) { 'owner' }
      
      it 'returns false' do
        expect(chat_member.valid?).to be(false)
      end
    end
  end
end