class CreateOperationTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :operation_types do |t|
      t.string :code, null: false, limit: 120
      t.string :label
      t.string :family, limit: 120

      t.timestamps
    end
  end
end
