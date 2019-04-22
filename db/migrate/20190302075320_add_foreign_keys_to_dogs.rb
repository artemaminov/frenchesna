class AddForeignKeysToDogs < ActiveRecord::Migration[5.2]
  def change
    change_table :dogs do |t|
      t.references :avatar, index: true, foreign_key: { to_table: :images }
      t.references :background, index: true, foreign_key: { to_table: :images }
    end
  end
end
