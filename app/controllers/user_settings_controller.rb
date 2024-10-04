class UserSettingsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user_setting = current_user.user_setting
  end

  def update
    @user_setting = current_user.user_setting
    if @user_setting.update(user_settings_params)
      redirect_to edit_user_settings_path(@user_setting), notice: 'Successfully updated'
    else
      redirect_to edit_user_settings_path(@user_setting), alert: 'Failed to update'
    end
  end

  private

  def user_settings_params
    params.require(:user_setting).permit(:notifications)
  end
end
