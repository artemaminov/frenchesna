class CreateDogs < ActiveRecord::Migration[5.2]
  def change
    create_table :dogs do |t|
      t.string :name
      t.string :nickname
      t.date :birthdate
      t.text :about
      t.integer :gender, default: 0
      t.integer :award_point
      t.boolean :rip
      t.references :father, index: true, foreign_key: true
      t.references :mother, index: true, foreign_key: true
      t.references :avatar, foreign_key: true
      t.references :background, foreign_key: true
    end
  end
end
