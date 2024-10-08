# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvitePolicy do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:workspace_test) { FactoryBot.create(:workspace, user: user) }
  let(:public_invite) { FactoryBot.create(:invite, user: user, workspace: workspace_test, status: 'unconfirmed', invite_type: 'public') }
  let(:private_invite) { FactoryBot.create(:invite, user: other_user, workspace: workspace_test, status: 'confirmed', invite_type: 'private') }

  describe '#confirmed?' do
    it 'returns true if the user is the owner of the workspace' do
      policy = InvitePolicy.new(user, public_invite)
      expect(policy.confirmed?).to be false
    end

    it 'returns false if the user is not the owner of the workspace' do
      policy = InvitePolicy.new(other_user, private_invite)
      expect(policy.confirmed?).to be true
    end
  end

  describe '#private?' do
    it 'returns true if the user is the owner of the workspace' do
      policy = InvitePolicy.new(user, public_invite)
      expect(policy.private?).to be false
    end

    it 'returns false if the user is not the owner of the workspace' do
      policy = InvitePolicy.new(other_user, private_invite)
      expect(policy.private?).to be true
    end
  end
end