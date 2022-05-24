ActiveAdmin.register Dog do

  index do
    # selectable_column
    column :breed
    column :puppy
    column :fullname
    column :nickname
    column :gender
    column :birthdate
    column :litter
    translation_status_flags
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

  permit_params :birthdate, :gender, :puppy, :rip, :mother_id, :father_id, :breed_id, :genealogy_link, :litter_id, avatar_attributes: [:id, :file, :crop, :resize, :_destroy], background_attributes: [:id], gallery_pictures_attributes: [:id, :file, :crop, :resize, :order, :_destroy], pictures_attributes: [:id, :order, :_destroy], litter_attributes: [:id, :title, :_destroy], translations_attributes: [:id, :locale, :fullname, :nickname, :about, :awards, :_destroy]

  form do |f|
    within head do
      script src: javascript_path('activestorage.js'), type: "text/javascript"
      script src: javascript_path('admin/direct_uploads.js'), type: "text/javascript"
      script src: javascript_path('admin/precrop.js'), type: "text/javascript"
      script src: javascript_path('admin/add_litter.js'), type: "text/javascript"
      link rel: "stylesheet", media: "screen", href: stylesheet_path('admin/direct_uploads.css')
      link rel: "stylesheet", media: "screen", href: stylesheet_path('admin/photos_helper.css')
    end
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Детали' do
      f.input :avatar, as: :file, allow_destroy: true, hint: (image_tag(crop_image f.object.avatar, :avatar, "100x100") unless f.object.avatar.blank?), input_html: { direct_upload: true, name: "dog[avatar_attributes][file]", class: 'rcrop', data: { rcrop_picture_type: 'avatar' }}

      f.input :puppy
      f.input :rip

      f.inputs "Translated fields" do
        f.translated_inputs 'ignored title', switch_locale: false, default_locale: :ru do |t|
          t.input :fullname
          t.input :nickname
          t.input :awards
          t.input :about
        end
      end

      f.input :breed
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

      # f.inputs "Translated fields" do
      #   f.translated_inputs 'ignored title', switch_locale: true, default_locale: :ru do |t|
      #     t.input :about
      #   end
      # end
    end
    f.inputs 'Изображения' do
      # byebug
      f.input :background, as: :radio, collection: f.object.backgroundable.map { |i| [(image_tag crop_image i, :picture, '100x100'), i.id, checked: i.viewable_type_scope == 'Background'] }, input_html: { name: 'dog[background_attributes][id]' } unless f.object.pictures.blank?
      panel "Управление изображениями", class: 'dragndrop' do
        f.has_many :pictures, sortable: :order, sortable_start: 1, allow_destroy: true, new_record: false, heading: false do |p|
          img_class = "dogs-background" if p.object == f.object.background
          img_class = "dogs-avatar" if p.object == f.object.avatar
          p.input :file, hint: link_to(
            image_tag(crop_image(p.object, :picture, '100x100')),
            p.object.file,
            class: img_class
          )
        end
        f.input :pictures, as: :file, input_html: { multiple: true, direct_upload: true, name: 'dog[gallery_pictures_attributes][][file]', class: 'rcrop', data: { rcrop_picture_type: 'picture' }}
      end
    end

    div id: 'rcrop_container'
    div id: 'rcrop_data'

    f.actions

    div id: 'rcrop_template' do
      div style: 'position: relative;' do
        img class: 'rcrop_cropper', style: 'width: 100%;'
        div class: 'rcrop_preview', style: 'position: absolute; top: 30px; left: 30px; border: 4px solid white;'
      end
    end
  end

  after_create do
    add_parents
  end

  controller do

    def update
      add_parents
      set_background
      update_avatar
      super
    end

    private

    def update_avatar
      if params[:dog][:avatar_attributes] && resource.avatar
        resource.avatar.file.attach params[:dog].delete(:avatar_attributes)[:file]
      end
    end

    def set_background
      return if params[:dog][:background_attributes].nil?

      current_background = resource.background
      new_background = resource.pictures.find(params[:dog].delete(:background_attributes)[:id])

      unless current_background.blank?
        return if current_background == new_background

        current_background.viewable_type_scope = 'Gallery'
        current_background.save

      end

      new_background.viewable_type_scope = 'Background'
      new_background.save
    end

    def add_parents
      old_parents = [resource.father_id, resource.mother_id]
      parents = [permitted_params[:dog][:mother_id], permitted_params[:dog][:father_id]]
      unless parents.include?(nil) || (parents - old_parents).empty?
        resource.parent_ids = parents
      end
    end

  end

end
