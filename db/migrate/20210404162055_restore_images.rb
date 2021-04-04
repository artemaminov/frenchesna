class RestoreImages < ActiveRecord::Migration[5.2]
  def change
    Image.find_each do |image|
      image.viewable_type_scope = image.viewable_type == 'Picture' ? 'Gallery' : image.viewable_type
      image.viewable_type = 'Dog'
      image.save
    end
  end
end
