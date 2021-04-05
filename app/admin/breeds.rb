ActiveAdmin.register Breed do
  permit_params :order, translations_attributes: [:id, :locale, :title, :info, :_destroy]

  index do
    column :order
    column :title
    translation_status_flags
    actions
  end

  form do |f|
    f.inputs 'Общие' do
      f.input :order
    end
    f.inputs "Translated fields" do
      f.translated_inputs 'ignored title', switch_locale: false, default_locale: :ru do |t|
        t.input :title
        t.input :info
      end
    end
    f.actions
  end
end
