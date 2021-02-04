class AddSenderIdToMessage < ActiveRecord::Migration[6.0]
  def change
    add_reference :messages, :sender, references: :users, index: true
  end
end
