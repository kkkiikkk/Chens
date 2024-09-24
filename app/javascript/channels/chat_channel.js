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

        if (data.action === 'create') {
          messagesContainer.insertAdjacentHTML('beforeend', data.message)
        }

        if (data.action === 'update') {
          const messageElement = document.getElementById(`message_${data.message_id}`)
          if (messageElement) {
            messageElement.outerHTML = data.message
          }
        }

        if (data.action === 'destroy') {
          const messageElement = document.getElementById(`message_${data.message_id}`)
          if (messageElement) {
            messageElement.remove()
          }
        }
      }
    })
  }
})
