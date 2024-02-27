class CreateServices < ActiveRecord::Migration[6.0]
    def change
      create_table :services do |t|
        t.string :name, null: false
        t.string :token, null: false
        t.string :alias, null: false
  
        t.timestamps
      end
      add_index :services, :alias, unique: true
    end
end 