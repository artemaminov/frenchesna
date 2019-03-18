ActiveAdmin.register Dog do

  index do
    # selectable_column
    column :fullname
    column :nickname
    column :gender
    column :award_point
    column :mother
    column :father
    column :birthdate, as: :datepicker
    column :rip
    actions
  end

  show do
    attributes_table do
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

  permit_params :fullname, :nickname, :birthdate, :about, :gender, :award_point, :rip, :father_id, :mother_id, :avatar_id, :background_id, pictures_attributes: [:id, :dog_id, :order, :file, :_destroy]

  form do |f|
    within head do
      script src: javascript_path('activestorage.js'), type: "text/javascript"
      script src: javascript_path('admin/direct_uploads.js'), type: "text/javascript"
      link rel: "stylesheet", media: "screen", href: stylesheet_path('admin/direct_uploads.css')
      link rel: "stylesheet", media: "screen", href: stylesheet_path('admin/photos_helper.css')
    end
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Details' do
      f.input :fullname
      f.input :nickname
      f.input :award_point
      f.input :mother
      f.input :father
      f.input :birthdate, as: :datepicker
      f.input :gender
      f.input :rip
    end
    f.inputs 'Content' do
      f.input :about
      f.input :avatar
      f.input :background
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
    def update
      update! do |format|
        format.html { redirect_to collection_path }
      end
    end
  end

end
