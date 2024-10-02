import consumer from "./consumer"

document.addEventListener('DOMContentLoaded', () => {
  const chatElement = document.getElementById('chat')
  
  if (chatElement) {
    const chatId = chatElement.dataset.chatId
    const workspaceId = chatElement.dataset.workspaceId
  
    const messageElements = document.querySelectorAll('.message')
    const observer = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const messageId = entry.target.dataset.messageId
          markMessageAsRead(messageId, workspaceId, chatId)
        }
      })
    }, {
      threshold: 1.0
    })

    messageElements.forEach(element => {
      observer.observe(element)
    })

    consumer.subscriptions.create({ channel: "ChatChannel", chat_id: chatId }, {
      connected() {
        console.log(`Connected to Chat ${chatId}`)
      },

      received(data) {
        const messagesContainer = document.getElementById('messages')

        if (data.action === 'create') {
          messagesContainer.insertAdjacentHTML('beforeend', data.message)
          console.log(data)
          const newMessageElement = document.querySelector(`#message_${data.message_id}`)
          
          if (newMessageElement) {
            const observerEntry = observer.takeRecords().find(entry => {
              console.log(entry.target)
              return entry.target === newMessageElement
            })

            if (observerEntry && observerEntry.isIntersecting) {
              markMessageAsRead(data.message_id, workspaceId, chatId)
            }
          }
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

        if (data.action === 'message_seen') {
          const messageElement = document.getElementById(`message_${data.message_id}`)
          if (messageElement) {
            const statusElement = messageElement.querySelector('.message-status')
            if (statusElement) {
              statusElement.innerHTML = `(Seen by ${data.seen_by.join(', ')})`
            }
          }
        }
        
      }
    })
  }
})

function markMessageAsRead(messageId, workspaceId, chatId) {
  const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

  fetch(`/workspaces/${workspaceId}/chats/${chatId}/messages/${messageId}/marks_as_read`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': token
    }
  })
  .then(response => {
    if (response.ok) {
      console.log(`Message ${messageId} marked as read`)
    }
  })
  .catch(error => console.error('Error:', error))
}
