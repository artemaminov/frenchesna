ActiveAdmin.register Dog do

  index do
    # selectable_column
    column :puppy
    column :fullname
    column :nickname
    column :gender
    column :birthdate
    column :litter
    actions
  end

  show do
    attributes_table do
      row :puppy
      row :fullname
      row :nickname
      row :awards
      row :birthdate
      row :gender
      row :rip
      row :about
    end
  end

  permit_params :fullname, :nickname, :birthdate, :about, :gender, :puppy, :awards, :rip, :mother_id, :father_id, :genealogy_link, :background_id, :litter_id, avatar_attributes: [:id, :dog_id, :file, :_destroy], pictures_ids: [], pictures: [], pictures_attributes: [:id, :dog_id, :order, :file, :_destroy], child_genealogies_attributes: [:id, :parent_id, :child_id], parents_genealogies_attributes: [:id, :parent_id, :child_id], parents_ids: [], kids_ids: [], litter_attributes: [:id, :title, :_destroy]

  form do |f|
    within head do
      script src: javascript_path('activestorage.js'), type: "text/javascript"
      script src: javascript_path('admin/direct_uploads.js'), type: "text/javascript"
      script src: javascript_path('admin/add_litter.js'), type: "text/javascript"
      link rel: "stylesheet", media: "screen", href: stylesheet_path('admin/direct_uploads.css')
      link rel: "stylesheet", media: "screen", href: stylesheet_path('admin/photos_helper.css')
    end
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Детали' do
      f.input :avatar, as: :file, allow_destroy: true, hint: (image_tag(f.object.avatar.file.variant(resize: "100x100").processed) unless f.object.avatar.blank?), input_html: { direct_upload: true, name: "dog[avatar_attributes][file]" }
      f.input :puppy
      f.input :rip
      f.input :fullname
      f.input :nickname
      f.input :awards
      f.input :mother_id, allow_blank: false, include_hidden: false, collection: Dog.adults.female.not_itself(f.object.id).map { |d| [d.fullname, d.id] }
      f.input :father_id, include_hidden: false, collection: Dog.adults.male.not_itself(f.object.id).map { |d| [d.fullname, d.id] }
      f.inputs id: 'add-litter' do
        f.input :litter
        li do
          label 'Добавить новый'
          f.button 'Добавить', type: 'button', onclick: 'console.log(addLitter(this));', 'data-add-litter-state': 'false'
        end
      end
      f.input :genealogy_link
      f.input :birthdate, as: :datepicker
      f.input :gender
      f.input :about
    end
    f.inputs 'Изображения' do
      f.input :background, as: :radio, collection: f.object.backgroundable.map { |i| [(image_tag i.file.variant(resize: "100x100").processed), i.id] } unless f.object.pictures.blank?
      panel "Управление изображениями", class: 'dragndrop' do
        f.has_many :pictures, sortable: :order, sortable_start: 1, allow_destroy: true, new_record: false, heading: false do |p|
          img_class = "dogs-background" if p.object == f.object.background
          img_class = "dogs-avatar" if p.object == f.object.avatar
          p.input :file, hint: image_tag(p.object.file.variant(resize: "100x100").processed, class: img_class)
        end
        f.input :pictures, as: :file, input_html: { multiple: true, direct_upload: true }
      end
    end
    f.actions
  end

  after_create do
    upload_avatar
    add_parents
  end

  before_update do
    # byebug

  end

  controller do

    def create
      # TODO Не верный permitted_params, содержит pictures[:file]
      modify_pictures_params
      create! do |success, failure|
        success.html { redirect_to collection_path }
      end
    end

    def update
      # byebug
      upload_avatar
      add_parents
      modify_pictures_params
      update! do |success, failure|
        success.html { redirect_to collection_path }
      end
    end

    private

    def modify_pictures_params
      unless permitted_params[:dog][:pictures].blank?
        if permitted_params[:dog][:pictures_attributes].blank?
          last_index = 0
          params[:dog][:pictures_attributes] = {}
        else
          last_index = permitted_params[:dog][:pictures_attributes].keys.count
        end
        pictures_params = params[:dog].delete :pictures
        pictures_hash = pictures_params.map { |file| {file: file}}
        pictures_hash.each_with_index do |file, index|
          # byebug
          picture_params = ActionController::Parameters.new(file)
          picture_params.permit :file
          # picture = resource.pictures.create file
          params[:dog][:pictures_attributes][(last_index + index).to_s] = picture_params
          # resource.save
        end
      end
    end

    def upload_avatar
      unless permitted_params[:dog][:avatar_attributes].blank?
        unless resource.avatar.blank?
          resource.avatar.file.purge
          # resource.avatar.destroy
        end
        avatar = resource.create_avatar dog: resource, file: permitted_params[:dog][:avatar_attributes]
        avatar.file.attach permitted_params[:dog][:avatar_attributes][:file]
        permitted_params[:dog].delete(:avatar_attributes)
        resource.avatar = avatar
        resource.save
      end
    end

    def add_parents
      old_parents = [resource.father_id, resource.mother_id]
      parents = [permitted_params[:dog][:mother_id], permitted_params[:dog][:father_id]]
      unless (parents - old_parents).empty?
        resource.parent_ids = parents
      end
    end

  end

end