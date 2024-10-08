# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChatMemberPolicy do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:other_user1) { FactoryBot.create(:user) }
  let(:workspace_test) { FactoryBot.create(:workspace, user: user) }
  let(:chat_test) { FactoryBot.create(:chat, workspace: workspace_test) }
  let(:chat_member) { FactoryBot.create(:chat_member, chat: chat_test, user: user, role: 'member') }
  let(:chat_moder) { FactoryBot.create(:chat_member, chat: chat_test, user: other_user, role: 'moder') }
  let(:chat_owner) { FactoryBot.create(:chat_member, chat: chat_test, user: other_user1, role: 'owner') }

  describe '#member?' do
    it 'returns true if the user is the owner of the workspace' do
      policy = ChatMemberPolicy.new(user, chat_member)
      expect(policy.member?).to be true
    end

    it 'returns false if the user is not the owner of the workspace' do
      policy = ChatMemberPolicy.new(other_user, chat_moder)
      expect(policy.member?).to be false
    end

    it 'returns false if the user is not the owner of the workspace' do
      policy = ChatMemberPolicy.new(other_user1, chat_owner)
      expect(policy.member?).to be false
    end
  end

  describe '#moder?' do
    it 'returns true if the user is the owner of the workspace' do
      policy = ChatMemberPolicy.new(user, chat_member)
      expect(policy.moder?).to be false
    end

    it 'returns false if the user is not the owner of the workspace' do
      policy = ChatMemberPolicy.new(other_user, chat_moder)
      expect(policy.moder?).to be true
    end

    it 'returns false if the user is not the owner of the workspace' do
      policy = ChatMemberPolicy.new(other_user1, chat_owner)
      expect(policy.moder?).to be false
    end
  end

  describe '#owner?' do
    it 'returns true if the user is the owner of the workspace' do
      policy = ChatMemberPolicy.new(user, chat_member)
      expect(policy.owner?).to be false
    end

    it 'returns false if the user is not the owner of the workspace' do
      policy = ChatMemberPolicy.new(other_user, chat_moder)
      expect(policy.owner?).to be false
    end

    it 'returns false if the user is not the owner of the workspace' do
      policy = ChatMemberPolicy.new(other_user1, chat_owner)
      expect(policy.owner?).to be true
    end
  end

  describe '#can_manage?' do
    it 'returns true if the user is the owner of the workspace' do
      policy = ChatMemberPolicy.new(user, chat_member)
      expect(policy.can_manage?).to be false
    end

    it 'returns false if the user is not the owner of the workspace' do
      policy = ChatMemberPolicy.new(other_user, chat_moder)
      expect(policy.can_manage?).to be true
    end

    it 'returns false if the user is not the owner of the workspace' do
      policy = ChatMemberPolicy.new(other_user1, chat_owner)
      expect(policy.can_manage?).to be true
    end
  end
end