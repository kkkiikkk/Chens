require 'rails_helper'

RSpec.describe Invite, type: :model do
  describe 'invite valid' do
    let(:workspace_owner) { FactoryBot.create(:user) }
    let(:workspace_test) { FactoryBot.create(:workspace, user: workspace_owner) }
    
    subject(:invite_test) { Invite.new(invite_type:, status:, email:, workspace:, user:) }

    context 'invite is valid' do
      let(:invite_type) { 'public' }
      let(:status) { 'unconfirmed' }
      let(:workspace) { workspace_test }
      let(:user) { workspace_owner }
      let(:email) { nil }

      it 'returns true' do
        expect(invite_test.valid?).to be(true)
      end
    end

    context 'invite, invite type is invalid' do
      let(:invite_type) { 'wrong type' }
      let(:status) { 'unconfirmed' }
      let(:workspace) { workspace_test }
      let(:user) { workspace_owner }
      let(:email) { nil }

      it 'returns false' do
        expect(invite_test.valid?).to be(false)
      end
    end

    context 'invite, status is invalid' do
      let(:invite_type) { 'public' }
      let(:status) { 'wrong status' }
      let(:workspace) { workspace_test }
      let(:user) { workspace_owner }
      let(:email) { nil }

      it 'returns false' do
        expect(invite_test.valid?).to be(false)
      end
    end

    context 'invite, workspace is invalid' do
      let(:invite_type) { 'public' }
      let(:status) { 'unconfirmed' }
      let(:workspace) { nil }
      let(:user) { workspace_owner }
      let(:email) { nil }

      it 'returns false' do
        expect(invite_test.valid?).to be(false)
      end
    end

    context 'invite, user is invalid' do
      let(:invite_type) { 'public' }
      let(:status) { 'unconfirmed' }
      let(:workspace) { workspace_test }
      let(:user) { nil }
      let(:email) { nil }

      it 'returns false' do
        expect(invite_test.valid?).to be(false)
      end
    end

    context 'invite, private invite is invalid' do
      let(:invite_type) { 'private' }
      let(:status) { 'unconfirmed' }
      let(:workspace) { workspace_test }
      let(:user) { workspace_owner }
      let(:email) { nil }

      it 'returns false' do
        expect(invite_test.valid?).to be(false)
      end
    end

    context 'invite, private invite is valid' do
      let(:invite_type) { 'private' }
      let(:status) { 'unconfirmed' }
      let(:workspace) { workspace_test }
      let(:user) { workspace_owner }
      let(:email) { workspace_owner.email }

      it 'returns true' do
        expect(invite_test.valid?).to be(true)
      end
    end
  end
end