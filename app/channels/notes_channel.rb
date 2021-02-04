class NotesChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from 'notes'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # def receive(data)
  #   note = Note.find(data["id"])
  #   #note.update!(text: data["message"])
  #   ActionCable.server.broadcast "id_#{data["id"]}", {
  #     message: data["message"]
  # }
  # end
  
  # def send_message(data)
  #   note = Note.find_by(id: data['id'])
  #   note.update!(text: data["message"])
  #   ActionCable.server.broadcast('notes', data)
  # end
  def speak(data)
    sender    = get_sender(data)
    room_id   = data['id']
    message   = data['text']

    raise 'No room_id!' if room_id.blank?
    convo = get_convo(room_id) # A conversation is a room
    raise 'No conversation found!' if convo.blank?
    raise 'No message!' if message.blank?

    # adds the message sender to the conversation if not already included
    convo.users << sender unless convo.users.include?(sender)
    # saves the message and its data to the DB
    # Note: this does not broadcast to the clients yet!
    Message.create!(
      conversation: convo,
      sender: sender,
      content: message
    )
  end

  def get_convo(room_code)
    Note.find_by(room_code: room_code)
  end
  
  def get_sender
    User.find_by(guid: id)
  end


end
