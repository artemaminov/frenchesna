class DeleteImageRelatedColumnsFromDogsTable < ActiveRecord::Migration[5.2]
  def change
    remove_columns :dogs, :avatar_id, :background_id
    remove_columns :images, :dog_id
  end
end
