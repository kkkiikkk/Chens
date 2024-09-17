class ChangeEmailToBeNullableInInvites < ActiveRecord::Migration[7.2]
  def change
    change_column_null :invites, :email, true
  end
end
