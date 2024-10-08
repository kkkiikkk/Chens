# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Workspace, type: :model do
  describe 'valid workspace' do
    FactoryBot.create(:user)

    subject(:workspace_test) { Workspace.new(user:, name:, description:) }
  
    context 'when workspace is valid' do
      let(:user) { User.last }
      let(:name) { 'Test workspace' }
      let(:description) { 'Test workspace description' }

      it 'returns true' do
        expect(workspace_test.valid?).to be(true)
      end
    end

    context 'when workspace user is invalid' do
      let(:name) { 'Test workspace' }
      let(:description) { 'Test workspace description' }
      let(:user) { nil }

      it 'returns false' do
        expect(workspace_test.valid?).to be(false)
      end
    end

    context 'when workspace description is invalid' do
      let(:user) { User.last }
      let(:name) { 'Test workspace' }
      let(:description) { nil }

      it 'returns false' do
        expect(workspace_test.valid?).to be(false)
      end
    end

     context 'when workspace name is invalid' do
      let(:user) { User.last }
      let(:description) { 'Test workspace description' }
      let(:name) { nil }

      it 'returns false' do
        expect(workspace_test.valid?).to be(false)
      end
    end
  end
end