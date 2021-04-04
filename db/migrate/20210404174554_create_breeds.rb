class CreateBreeds < ActiveRecord::Migration[5.2]
  def change
    create_table :breeds do |t|
      t.string :title
      t.integer :order
      t.text :info

      t.timestamps
    end

    change_column_default :breeds, :order, 1
  end
end
