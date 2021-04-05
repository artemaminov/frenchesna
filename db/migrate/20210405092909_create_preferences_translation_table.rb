class CreatePreferencesTranslationTable < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        Preference.create_translation_table!({ about: :text }, { migrate_data: true })
      end

      dir.down do
        Preference.drop_translation_table! migrate_data: true
      end
    end
  end
end
