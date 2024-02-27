class CreateParameters < ActiveRecord::Migration[6.0]
    def change
      create_table :parameters do |t|
        t.string :name, limit: 120, null: false
        t.text :value, null: false
        t.text :description
        t.string :slug, limit:50, null: false

        t.timestamps
      end
      add_index :parameters, :slug, unique: true
    end
end
  