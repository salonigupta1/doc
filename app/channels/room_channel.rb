class RoomChannel < ApplicationCable::Channel
  # calls when a client connects to the server
  def subscribed
    #if params[:id].present?
      # creates a private chat room with a unique name
      stream_from("Room")
    #end
  end
  
  # calls when a client broadcasts data
  def speak(data)
    sender    = get_sender(data)
    room_id   = data['id']
    message   = data['message']


    raise 'No room_id!' if room_id.blank?
    convo = get_convo(room_id) # A conversation is a room
    raise 'No conversation found!' if convo.blank?
    raise 'No message!' if message.blank?

    # adds the message sender to the conversation if not already included
    #convo.users << sender unless convo.users.include?(sender)
    # saves the message and its data to the DB
    # Note: this does not broadcast to the clients yet!
    Message.create!(
      conversation: convo,
      sender: sender,
      content: message
    )
  end
  
  # Helpers
  
  def get_convo(room_code)
    Conversation.find(room_code)
  end
  
  def get_sender(data)
    id = data['user_id']
    User.find(id)
  end
end