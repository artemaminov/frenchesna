class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.references :dog, foreign_key: true
      t.integer :order

      t.timestamps
    end
  end
end
