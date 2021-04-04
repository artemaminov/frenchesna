class MoveImagesRelatedDataFromDogsToImagesTable < ActiveRecord::Migration[5.2]
  def change
    Image.update_all viewable_type: 'Picture'
    Dog.find_each do |dog|
      pictures = Image.where(dog_id: dog.id)
      pictures.update_all viewable_id: dog.id
      avatar_image = Image.find_by(id: dog.avatar_id)
      unless avatar_image.blank?
        avatar_image.update_columns viewable_id: dog.id, viewable_type: 'Avatar'
      end
      background_image = Image.find_by(id: dog.background_id)
      unless background_image.blank?
        background_image.update_columns viewable_id: dog.id, viewable_type: 'Background'
      end
    end
  end
end
