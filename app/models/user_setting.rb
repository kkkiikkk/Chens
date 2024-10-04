class UserSetting < ApplicationRecord
  belongs_to :user

  validates :notifications, inclusion: { in: [true, false], message: "Wrong status" }
end
