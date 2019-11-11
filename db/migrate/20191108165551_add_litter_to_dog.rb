class AddLitterToDog < ActiveRecord::Migration[5.2]
  def change
    add_reference :dogs, :litter, foreign_key: true
  end
end
