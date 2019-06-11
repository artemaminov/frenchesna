class AddGenealogyLinkToDogsTable < ActiveRecord::Migration[5.2]
  def change
    add_column :dogs, :genealogy_link, :string
  end
end
