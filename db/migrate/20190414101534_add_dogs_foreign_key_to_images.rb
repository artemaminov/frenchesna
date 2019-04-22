class AddDogsForeignKeyToImages < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :images, :dogs
  end
end
