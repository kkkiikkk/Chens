require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'message valid' do
    let(:workspace_owner) { FactoryBot.create(:user) }
    let(:workspace_test) { FactoryBot.create(:workspace, user: workspace_owner) }
    let(:chat_test) { FactoryBot.create(:chat, workspace: workspace_test) }

    subject(:message_test) { Message.new(sender:, chat:) }
    
    context 'when message is valid' do
      let(:sender) { workspace_owner }
      let(:chat) { chat_test }

      it 'returns true' do
        expect(message_test.valid?).to be(true)
      end
    end

    context 'when message sender is invalid' do
      let(:sender) { nil }
      let(:chat) { chat_test }

      it 'returns false' do
        expect(message_test.valid?).to be(false)
      end
    end

    context 'when message chat is invalid' do
      let(:sender) { workspace_owner }
      let(:chat) { nil }

      it 'returns false' do
        expect(message_test.valid?).to be(false)
      end
    end
  end
end