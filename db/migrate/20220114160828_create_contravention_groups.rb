class CreateContraventionGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :contravention_groups do |t|
      t.string :code, null: false, limit: 120
      t.string :label
      t.text :description

      t.timestamps
    end

    add_index :contravention_groups, :code, unique: true
  end
end
