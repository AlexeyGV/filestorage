class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :path, null: false
      t.string :original_filename, null: false

      t.timestamps
    end
  end
end
