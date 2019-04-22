class CreateGenealogies < ActiveRecord::Migration[5.2]
  def change
    create_table :genealogies do |t|
      t.references :parent, index: true, foreign_key: { to_table: :dogs }
      t.references :child, index: true, foreign_key: { to_table: :dogs }
    end
  end
end
