class AddAboutToPreferences < ActiveRecord::Migration[5.2]
  def change
    add_column :preferences, :about, :text
  end
end
