class User < ApplicationRecord
  has_many :user_workspaces, dependent: :destroy
  has_many :workspaces, through: :user_workspaces
  has_one_attached :avatar

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:google_oauth2]

  validates :name, presence: true
  validate :avatar_format

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).or(where(email: auth.info.email)).first

    unless user
      user = create do |new_user|
        new_user.email = auth.info.email
        new_user.name = auth.info.name || auth.info.first_name
        new_user.password = Devise.friendly_token[0, 20]
        new_user.provider = auth.provider
        new_user.uid = auth.uid
      end
    end

    user
  end

  private

  def avatar_format
    return unless avatar.attached?

    unless avatar.content_type.in?(%w[image/jpeg image/png image/gif])
      errors.add(:avatar, 'must be a JPEG, PNG, or GIF image')
    end
  end
end
