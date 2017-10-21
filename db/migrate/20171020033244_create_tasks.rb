class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.integer   :user_id
      t.integer   :project_id
      t.integer   :assigned_to
      t.string    :name
      t.text      :description
      t.date      :start_date
      t.date      :end_date
      t.string    :priority
      t.string    :status
      t.float     :progress, default: 0.0

      t.timestamps
    end
  end
end
