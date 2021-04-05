class CreateTranslationTables < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        Breed.create_translation_table!({ title: :string, info: :text }, { migrate_data: true })
        Dog.create_translation_table!({ fullname: :string, nickname: :string, about: :text, awards: :text }, { migrate_data: true })
        Litter.create_translation_table!({ title: :string }, { migrate_data: true })
      end

      dir.down do
        Breed.drop_translation_table! migrate_data: true
        Dog.drop_translation_table! migrate_data: true
        Litter.drop_translation_table! migrate_data: true
      end
    end
  end
end
