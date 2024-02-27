class RemoveIndexQuittanceNumberFromDeclarations < ActiveRecord::Migration[6.0]
    def change
        remove_index :declarations, :quittance_number
        add_index :declarations, :quittance_number
    end
end