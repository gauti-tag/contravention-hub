class CreatePlatforms < ActiveRecord::Migration[6.0]
  def change
    create_table :platforms do |t|
      t.string :name
      t.string :api_key
      t.text :api_secret

      t.timestamps
    end
  end
end
