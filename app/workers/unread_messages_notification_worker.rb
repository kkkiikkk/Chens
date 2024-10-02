class UnreadMessagesNotificationWorker
  include Sidekiq::Worker

  def perform
    User.find_each do |user|
      unread_messages = UnreadMessagesQuery.new(user).unread_messages

      next if unread_messages.empty?

      MessageMailer.unread_messages(user, unread_messages).deliver_now
    end
  end
end