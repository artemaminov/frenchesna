class CreateLitters < ActiveRecord::Migration[5.2]
  def change
    create_table :litters do |t|
      t.string :title

      t.timestamps
    end
  end
end
