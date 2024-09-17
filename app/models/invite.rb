class Invite < ApplicationRecord
  belongs_to :workspace
  belongs_to :user

  before_create :generate_token

  validates :invite_type, inclusion: { in: %w[public private], message: "%{value} is not a valid type" }
  validates :status, inclusion: { in: %w[unconfirmed confirmed], message: "%{value} is not a valid type" }
  validates :email, presence: true, if: :private_invite?

  private

  def generate_token
    self.token = SecureRandom.hex(10)
  end

  def private_invite?
    invite_type == 'private'
  end
end
