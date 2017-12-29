class MakeNotesPolymorphic < ActiveRecord::Migration[5.1]
  def change
    remove_reference :notes, :project
    add_reference :notes, :notable, polymorphic: true
  end
end
