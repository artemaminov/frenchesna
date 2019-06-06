class ChangeAwardPointFiledToAwards < ActiveRecord::Migration[5.2]
  def change
    rename_column :dogs, :award_point, :awards
    change_column :dogs, :awards, :text
  end
end
