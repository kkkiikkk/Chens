# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserWorkspacePolicy do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:workspace_test) { FactoryBot.create(:workspace, user: user) }
  let(:workspace_owner) { FactoryBot.create(:user_workspace, user: user, workspace: workspace_test, role: 'owner') }
  let(:workspace_member) { FactoryBot.create(:user_workspace, user: user, workspace: workspace_test, role: 'member') }

  describe '#can_manage?' do
    it 'returns true if the user is the owner of the workspace' do
      policy = UserWorkspacePolicy.new(user, workspace_owner)
      expect(policy.can_manage?).to be true
    end

    it 'returns false if the user is not the owner of the workspace' do
      policy = UserWorkspacePolicy.new(other_user, workspace_member)
      expect(policy.can_manage?).to be false
    end
  end

  describe '#blocked?' do
    it 'returns true if the user is the owner of the workspace' do
      policy = UserWorkspacePolicy.new(user, workspace_owner)
      expect(policy.blocked?).to be false
    end

    it 'returns false if the user is not the owner of the workspace' do
      policy = UserWorkspacePolicy.new(other_user, workspace_member)
      expect(policy.blocked?).to be false
    end
  end
end