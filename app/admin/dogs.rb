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
      row :award_point
      # row :mother
      # row :father
      row :birthdate, as: :datepicker
      row :gender
      row :rip
      row :about
    end
  end

  permit_params :fullname, :nickname, :birthdate, :about, :gender, :puppy, :award_point, :rip, :mother, :father, :background_id, avatar_attributes: [:id, :dog_id, :file, :_destroy], pictures_attributes: [:id, :dog_id, :order, :file, :_destroy], child_genealogies_attributes: [:id, :parent_id, :child_id], parents_genealogies_attributes: [:id, :parent_id, :child_id], parents_ids: [], kids_ids: []

  form do |f|
    within head do
      script src: javascript_path('activestorage.js'), type: "text/javascript"
      script src: javascript_path('admin/direct_uploads.js'), type: "text/javascript"
      link rel: "stylesheet", media: "screen", href: stylesheet_path('admin/direct_uploads.css')
      link rel: "stylesheet", media: "screen", href: stylesheet_path('admin/photos_helper.css')
    end
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Details' do
      f.input :avatar, as: :file, allow_destroy: true, hint: (image_tag(f.object.avatar.file.variant(resize: "100x100").processed) unless f.object.avatar.blank?), input_html: { direct_upload: true, name: "dog[avatar_attributes][file]" }
      f.input :puppy
      f.input :fullname
      f.input :nickname
      f.input :award_point
      f.input :mother, allow_blank: false, include_hidden: false, collection: Dog.adults.female.map { |d| [d.fullname, d.id] }
      f.input :father, include_hidden: false, collection: Dog.adults.male.map { |d| [d.fullname, d.id] }
      f.input :birthdate, as: :datepicker
      f.input :gender
      f.input :rip
    end
    f.inputs 'Content' do
      f.input :about
      panel "Images" do
        div class: "dogs-photos-list" do
          # ; f.input :_destroy, as: :boolean, required: false
          f.input :background, as: :radio, collection: f.object.backgroundable.map { |i| [(image_tag i.file.variant(resize: "100x100").processed), i.id] } unless f.object.pictures.blank?
          f.input :pictures, as: :file, input_html: { multiple: true, direct_upload: true, name: "dog[pictures_attributes][][file]" }
          panel "All images" do
            # f.has_many :pictures, sortable: :order, sortable_start: 1, allow_destroy: true, new_record: false do |p|
            #   # render partial: "dog_photos", locals: { dog: f.object, image: p.object }
            #   img_class = "dogs-background" if f.object.background == p.object
            #   p.input :file, hint: image_tag(p.object.file.variant(resize: "100x100").processed, class: img_class)
            # end
          end
        end
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
