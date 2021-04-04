class AddBreedToDogsTable < ActiveRecord::Migration[5.2]
  def change
    add_reference :dogs, :breed
  end
end
