class RemoveIndexToContraventionNotebooks < ActiveRecord::Migration[6.0]
    def change
        remove_index :contravention_notebooks, :number 
    end
end
