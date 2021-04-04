class AddTypeScopeToImage < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :viewable_type_scope, :string
  end
end
