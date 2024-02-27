class AddStatusToContraventionTypes < ActiveRecord::Migration[6.0]
    def change
        add_column :contravention_types, :status, :integer, default: 1
    end
end