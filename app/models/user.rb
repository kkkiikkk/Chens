class User < ApplicationRecord
  has_many :user_workspaces, dependent: :destroy
  has_many :workspaces, through: :user_workspaces
  has_one_attached :avatar

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  validates :name, presence: true
  validate :avatar_format
  
  private

  def avatar_format
    return unless avatar.attached?
    
    unless avatar.content_type.in?(%w[image/jpeg image/png image/gif])
      errors.add(:avatar, 'must be a JPEG, PNG, or GIF image')
    end
  end
end
