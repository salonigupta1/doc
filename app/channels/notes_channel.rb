class NotesChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from 'notes'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    note = Note.find(data["id"])
    note.update!(text: data["message"])
    ActionCable.server.broadcast "id_#{1}", {
      message: data["message"]
  }
  end
  
  def send_message(data)
    note = Note.find_by(id: data['id'])
    note.update!(text: data["message"])
    ActionCable.server.broadcast('notes', data)
  end

end
