class AddViewableToImagesTable < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :viewable_id, :integer
    add_column :images, :viewable_type, :string
    change_column_default :images, :order, 1
  end
end
