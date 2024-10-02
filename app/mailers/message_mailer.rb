class MessageMailer < ApplicationMailer
  def unread_messages(user, messages)
    @user = user
    @messages = messages

    mail(to: @user.email, subject: 'You have unread messages')
  end
end