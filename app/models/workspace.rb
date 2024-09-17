class Workspace < ApplicationRecord
  has_many :user_workspaces, dependent: :destroy
  has_many :users, through: :user_workspaces
  has_many :invites
  belongs_to :user

  has_one_attached :picture
end
