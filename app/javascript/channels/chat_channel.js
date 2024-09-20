import consumer from "./consumer"

document.addEventListener('DOMContentLoaded', () => {
  const chatElement = document.getElementById('chat')
  
  if (chatElement) {
    const chatId = chatElement.dataset.chatId

    consumer.subscriptions.create({ channel: "ChatChannel", chat_id: chatId }, {
      connected() {
        console.log(`Connected to Chat ${chatId}`)
      },

      received(data) {
        const messagesContainer = document.getElementById('messages')
        if (messagesContainer) {
          messagesContainer.insertAdjacentHTML('beforeend', data.message)
        } else {
          console.log("Messages container not found.")
        }
      }
    })
  }
})
