ActiveAdmin.register Dog do

  index do
    # selectable_column
    column :puppy
    column :fullname
    column :nickname
    column :gender
    column :birthdate, as: :datepicker
    actions
  end

  show do
    attributes_table do
      row :puppy
      row :fullname
      row :nickname
      row :awards
      # row :mother
      # row :father
      row :birthdate, as: :datepicker
      row :gender
      row :rip
      row :about
    end
  end

  permit_params :fullname, :nickname, :birthdate, :about, :gender, :puppy, :awards, :rip, :mother, :father, :genealogy_link, :background_id, avatar_attributes: [:id, :dog_id, :file, :_destroy], pictures_attributes: [:id, :dog_id, :order, :file, :_destroy], child_genealogies_attributes: [:id, :parent_id, :child_id], parents_genealogies_attributes: [:id, :parent_id, :child_id], parents_ids: [], kids_ids: []

  form do |f|
    within head do
      script src: javascript_path('activestorage.js'), type: "text/javascript"
      script src: javascript_path('admin/direct_uploads.js'), type: "text/javascript"
      link rel: "stylesheet", media: "screen", href: stylesheet_path('admin/direct_uploads.css')
      link rel: "stylesheet", media: "screen", href: stylesheet_path('admin/photos_helper.css')
    end
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Детали' do
      f.input :avatar, as: :file, allow_destroy: true, hint: (image_tag(f.object.avatar.file.variant(resize: "100x100").processed) unless f.object.avatar.blank?), input_html: { direct_upload: true, name: "dog[avatar_attributes][file]" }
      f.input :puppy
      f.input :fullname
      f.input :nickname
      f.input :awards
      f.input :mother, allow_blank: false, include_hidden: false, collection: Dog.adults.female.map { |d| [d.fullname, d.id] }
      f.input :father, include_hidden: false, collection: Dog.adults.male.map { |d| [d.fullname, d.id] }
      f.input :genealogy_link
      f.input :birthdate, as: :datepicker
      f.input :gender
      f.input :rip
      f.input :about
    end
    f.inputs 'Изображения' do
      f.input :background, as: :radio, collection: f.object.backgroundable.map { |i| [(image_tag i.file.variant(resize: "100x100").processed), i.id] } unless f.object.pictures.blank?
      panel "Управление изображениями", class: 'dragndrop' do
        f.has_many :pictures, sortable: :order, sortable_start: 1, allow_destroy: true, new_record: false, heading: false do |p|
          # render partial: "dog_photos", locals: { dog: f.object, image: p.object }
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
    upload_avatar
    add_parents
  end

  controller do

    def create
      create! do |format|
        format.html { redirect_to collection_path }
      end
    end
    
    def update
      unless params[:dog][:pictures].blank?
        if params[:dog][:pictures_attributes].blank?
          params[:dog][:pictures_attributes] = {}
        end
        last_index = params[:dog][:pictures_attributes].keys.last.to_i
        new_pictures_hash = params[:dog][:pictures].map { |file| {file: file}}
        new_pictures_hash.each_with_index { |picture, index| params[:dog][:pictures_attributes][(last_index + index).to_s] = ActionController::Parameters.new picture }
      end
      update! do |format|
        format.html { redirect_to collection_path }
      end
    end

    private

    def upload_avatar
      avatar_input = permitted_params[:dog][:avatar_attributes]
      if avatar_input
        existent_avatar = resource.avatar
        unless existent_avatar.new_record?
          resource.avatar.file.purge
          resource.avatar.destroy
        end
        avatar = resource.create_avatar dog: resource, file: permitted_params[:dog][:avatar_attributes]
        resource.avatar = avatar
        resource.avatar.file.attach permitted_params[:dog][:avatar_attributes][:file]
        resource.save
      end
    end

    def add_parents
      old_parents = [resource.father, resource.mother]
      parents = [permitted_params[:dog][:mother], permitted_params[:dog][:father]]
      unless (parents - old_parents).empty?
        resource.parent_ids = parents
      end
    end

  end

end