class AddColumnResizeToImages < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :resize, :string
  end
end
