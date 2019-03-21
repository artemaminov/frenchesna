class CreateDogs < ActiveRecord::Migration[5.2]
  def change
    create_table :dogs do |t|
      t.string :fullname
      t.string :nickname
      t.date :birthdate
      t.text :about
      t.integer :gender, default: 0
      t.integer :award_point
      t.boolean :puppy, default: true
      t.boolean :rip, default: true
      t.references :father, index: true, foreign_key: { to_table: :dogs }
      t.references :mother, index: true, foreign_key: { to_table: :dogs }
      t.references :avatar, foreign_key: { to_table: :images }
      t.references :background, foreign_key: { to_table: :images }
    end
  end
end
