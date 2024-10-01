class ChatMembersMailer < ApplicationMailer
  def remove_from_the_chat(user, chat)
    @user = user
    @chat = chat

    mail(to: @user.email, subject: "Remove from the #{@chat.name} chat")
  end

  def change_role(chat_member)
    @chat_member = chat_member

    mail(to: @chat_member.user.email, subject: 'Your role was updated')
  end
end