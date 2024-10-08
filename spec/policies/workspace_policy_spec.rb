# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkspacePolicy do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:workspace) { FactoryBot.create(:workspace, user: user) }

  describe '#can_destroy?' do
    it 'returns true if the user is the owner of the workspace' do
      policy = WorkspacePolicy.new(user, workspace)
      expect(policy.can_destroy?).to be true
    end

    it 'returns false if the user is not the owner of the workspace' do
      policy = WorkspacePolicy.new(other_user, workspace)
      expect(policy.can_destroy?).to be false
    end
  end

  describe '#owner?' do
    it 'returns true if the user is the owner of the workspace' do
      policy = WorkspacePolicy.new(user, workspace)
      expect(policy.owner?).to be true
    end

    it 'returns false if the user is not the owner of the workspace' do
      policy = WorkspacePolicy.new(other_user, workspace)
      expect(policy.owner?).to be false
    end
  end
end
