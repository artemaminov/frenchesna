ActiveAdmin.register Preference do
  permit_params :background, translations_attributes: [:id, :locale, :about, :_destroy]

  index do
    translation_status_flags
    actions
  end

  form do |f|
    within head do
      script src: javascript_path('activestorage.js'), type: "text/javascript"
      script src: javascript_path('admin/direct_uploads.js'), type: "text/javascript"
      link rel: "stylesheet", media: "screen", href: stylesheet_path('admin/direct_uploads.css')
      link rel: "stylesheet", media: "screen", href: stylesheet_path('admin/photos_helper.css')
    end
    f.semantic_errors *f.object.errors.keys
    f.inputs "Preferences" do
      if f.object.file.attached?
        hint = image_tag(f.object.file.variant(resize: "100x100").processed)
      end
      f.input :file, as: :file, input_html: { direct_upload: true }, hint: hint
    end

    f.inputs "Translated fields" do
      f.translated_inputs 'ignored title', switch_locale: false, default_locale: :ru do |t|
        t.input :about
      end
    end

    f.actions
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
  end
end