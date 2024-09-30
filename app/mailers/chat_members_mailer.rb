class ChatMembersMailer < ApplicationMailer
  def remove_from_the_chat(user, chat)
    @user = user
    @chat = chat
    p user
    p chat
    mail(to: @user.email, subjecct: "Remove from the #{@chat.name} chat")
  end
end