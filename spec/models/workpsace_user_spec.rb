require 'rails_helper'

RSpec.describe UserWorkspace, type: :model do
  describe 'workspace user valid' do
    let(:workspace_owner) { FactoryBot.create(:user) }
    let(:workspace_member) { FactoryBot.create(:user) }
    let(:workspace_test) { FactoryBot.create(:workspace, user: workspace_owner) }

    subject(:workspace_user_test) { UserWorkspace.new(user: user, profile_status: profile_status, role: role, workspace: workspace_test) }

    context 'when user workspace is valid' do
      let(:user) { workspace_member }
      let(:profile_status) { 'away' }
      let(:role) { 'member' }

      it 'returns true' do
        expect(workspace_user_test.valid?).to be(true)
      end
    end

    context 'when user workspace profile status is invalid' do
      let(:user) { workspace_member }
      let(:role) { 'member' }
      let(:profile_status) { 'some wrong staus' }

      it 'returns false' do
        expect(workspace_user_test.valid?).to be(false)
      end
    end

    context 'when user workspace role is invalid' do
      let(:user) { workspace_member }
      let(:profile_status) { 'away' }
      let(:role) { 'wrong role' }

      it 'returns false' do
        expect(workspace_user_test.valid?).to be(false)
      end
    end

    context 'when user wokrspace with invalid user' do
      let(:profile_status) { 'away' }
      let(:role) { 'wrong role' }
      let(:user) { nil }

      it 'returns false' do
        expect(workspace_user_test.valid?).to be(false)
      end
    end
  end
end