class DeleteArchiveChatsWorker < ApplicationWorker
  def execute
    three_months_ago = 3.months.ago
    chats = Chat.archive.where(Chat.arel_table[:updated_at].lt(three_months_ago))

    ActiveRecord::Base.transaction do
      chats.each do |chat|
        chat.destroy
      end
    end
  end
end
