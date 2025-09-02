class CreateSupportWidgets < ActiveRecord::Migration[6.1]
  def change
    create_table :support_widgets do |t|
      t.string :name
      t.integer :project_id
      t.integer :tracker_id
      t.integer :status_id
      t.integer :priority_id
      t.integer :assigned_to_id
      t.text :embed_code
      t.string :token, unique: true

      t.timestamps
    end
  end
end
