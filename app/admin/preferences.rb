ActiveAdmin.register Preference do
  permit_params :background

  form do |f|
    within head do
      script src: javascript_path('activestorage.js'), type: "text/javascript"
      script src: javascript_path('admin/direct_uploads.js'), type: "text/javascript"
      link rel: "stylesheet", media: "screen", href: stylesheet_path('admin/direct_uploads.css')
      link rel: "stylesheet", media: "screen", href: stylesheet_path('admin/photos_helper.css')
    end
    f.semantic_errors *f.object.errors.keys
    f.inputs "Preferences" do
      if f.object.background.attached?
        hint = image_tag(f.object.background.variant(resize: "100x100").processed)
      end
      f.input :background, as: :file, input_html: { direct_upload: true }, hint: hint
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