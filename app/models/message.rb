class Message < ApplicationRecord
    belongs_to :conversation
    belongs_to :sender, class_name: :User, foreign_key: 'sender_id'
  
    validates_presence_of :content
  
    after_create_commit { MessageBroadcastJob.perform_now(self) }
  end