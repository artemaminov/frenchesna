class RemoveParentsFieldsFromDogs < ActiveRecord::Migration[5.2]
  def change
    remove_reference :dogs, :mother, index: true, foreign_key: { to_table: :dogs }
    remove_reference :dogs, :father, index: true, foreign_key: { to_table: :dogs }
  end
end
