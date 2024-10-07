require 'rails_helper'

RSpec.describe MessageRead, type: :model do
  describe 'message read valid' do
    let(:workspace_owner) { FactoryBot.create(:user) }
    let(:workspace_test) { FactoryBot.create(:workspace, user: workspace_owner) }
    let(:chat_test) { FactoryBot.create(:chat, workspace: workspace_test) }
    let(:message_test) { FactoryBot.create(:message, sender: workspace_owner, chat: chat_test) }

    subject(:message_read) { MessageRead.new(user:, message:) }

    context 'message read is valid' do
      let(:user) { workspace_owner }
      let(:message) { message_test }

      it 'returns true' do
        expect(message_read.valid?).to be(true)
      end
    end

    context 'message read user is invalid' do
      let(:user) { nil }
      let(:message) { message_test }

      it 'returns false' do
        expect(message_read.valid?).to be(false)
      end
    end

    context 'message read message is invalid' do
      let(:user) { workspace_owner }
      let(:message) { nil }

      it 'returns false' do
        expect(message_read.valid?).to be(false)
      end
    end
  end
end
