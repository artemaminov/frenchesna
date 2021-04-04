class RestoreImages < ActiveRecord::Migration[5.2]
  def change
    Image.find_each do |image|
      image.viewable_type_scope = image.viewable_type == 'Picture' ? 'Gallery' : image.viewable_type
      image.save
    end
    Image.update_all viewable_type: 'Dog'
  end
end
