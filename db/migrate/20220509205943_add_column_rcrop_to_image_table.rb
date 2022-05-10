class AddColumnRcropToImageTable < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :rcrop, :string
  end
end
