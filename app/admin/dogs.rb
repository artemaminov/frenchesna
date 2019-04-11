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
      row :mother
      row :father
      row :birthdate, as: :datepicker
      row :gender
      row :rip
      row :about
    end
  end

  permit_params :fullname, :nickname, :birthdate, :about, :gender, :puppy, :award_point, :rip, :father_id, :mother_id, :avatar_id, :background_id, pictures_attributes: [:id, :dog_id, :order, :file, :_destroy]

  form do |f|
    within head do
      script src: javascript_path('activestorage.js'), type: "text/javascript"
      script src: javascript_path('admin/direct_uploads.js'), type: "text/javascript"
      link rel: "stylesheet", media: "screen", href: stylesheet_path('admin/direct_uploads.css')
      link rel: "stylesheet", media: "screen", href: stylesheet_path('admin/photos_helper.css')
    end
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Details' do
      f.input :puppy
      f.input :fullname
      f.input :nickname
      f.input :award_point
      f.input :mother, :collection => Dog.parentable.female.map { |d| [d.fullname, d.id] }
      f.input :father, collection: Dog.parentable.male.map { |d| [d.fullname, d.id] }
      f.input :birthdate, as: :datepicker
      f.input :gender
      f.input :rip
    end
    f.inputs 'Content' do
      f.input :about
      f.input :avatar, as: :file, hint: (image_tag(f.object.avatar.file) unless f.object.avatar.blank?)
      f.input :background, as: :check_boxes, collection: f.object.pictures.map { |i| [(image_tag i.file), i.id] }
      panel "Images" do
        div class: "dogs-photos-list" do
          f.has_many :pictures, sortable: :order, sortable_start: 1, allow_destroy: true, new_record: false do |p|
          # render partial: "dog_photos", locals: { dog: f.object, image: p.object }
            img_class = "dogs-background" if f.object.background == p.object
            p.input :file, hint: image_tag(p.object.file.variant(resize: "100x100").processed, class: img_class)
          end
        end
        f.input :pictures, as: :file, input_html: { multiple: true, direct_upload: true, name: "dog[pictures_attributes][][file]" }
      end
    end
    f.actions
  end

  controller do
    def create
      update! do |format|
        format.html { redirect_to collection_path }
      end
    end
    
    def update
      update! do |format|
        format.html { redirect_to collection_path }
      end
    end
  end

end
