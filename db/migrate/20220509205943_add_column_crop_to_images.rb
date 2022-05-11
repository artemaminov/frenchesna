class AddColumnCropToImages < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :crop, :string
  end
end
