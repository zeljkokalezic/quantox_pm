class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.references :user, foreign_key: true
      t.timestamp :deadline
      t.integer :priority
      t.integer :status
      t.integer :type
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
