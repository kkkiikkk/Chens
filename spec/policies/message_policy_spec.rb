# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessagePolicy do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:workspace_test) { FactoryBot.create(:workspace, user: user) }
  let(:chat_test) { FactoryBot.create(:chat, workspace: workspace_test) }
  let(:message1) { FactoryBot.create(:message, chat: chat_test, sender: user) }
  let(:message2) { FactoryBot.create(:message, chat: chat_test, sender: other_user) }
  let(:message_read1) { FactoryBot.create(:message_read, message: message1, user: other_user) }

  describe '#seen?' do
    it 'returns false if the user is not the owner of the workspace' do
      policy = MessagePolicy.new(other_user, message2)
      expect(policy.seen?).to be false
    end
  end
end
