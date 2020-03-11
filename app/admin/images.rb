ActiveAdmin.register Image do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :images
config.filters = false
config.paginate = false
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
#   index as: ActiveAdmin::Views::IndexForImages do
  index download_links: false, paginator: false do # pagination_total: false
    div do
      para "Всего изображений #{total_images}"
      br
      para "Из них, аватарок #{avatars}"
      para "Из них, аватарок потеряно #{avatars_lost.length}"
      div do
        link_to t(:nullify_orphaned), nullify_orphan_records_admin_images_path(type: 'avatar', dog: avatars_lost), method: :put, data: { confirm: t(:sure?) }
      end
      br
      para "Из них, фото #{photos}"
      para "Без обратной связи с таблицей собак #{no_reverse_reference.length}"
      div do
        link_to no_reverse_reference, data: { confirm: t(:sure?) }
      end
      para "Мусор"
      div do
        link_to orphan_records, fix_references_admin_images_path, data: { confirm: t(:sure?) }
      end
      # div do
      #   para no_reverse_reference - orphan_records
      # end
      br
      para "Из них, фоновых #{backgrounds}"
      para "Из них, фоновых потеряно #{backgrounds_lost.length}"
      div do
        link_to t(:nullify_orphaned), nullify_orphan_records_admin_images_path(type: 'background', dog: backgrounds_lost), method: :put, data: { confirm: t(:sure?) }
      end
    end
  end

  collection_action :nullify_orphan_records, method: :put do
    redirect_to collection_path, notice: t(:orphan_columns_set_to_null)
  end

  collection_action :fix_references do
    redirect_to collection_path, notice: t(:references_fixed)
  end

  controller do
    def index
      @total_images = Image.total_images
      @photos = Image.photos
      @avatars = Image.avatars
      @avatars_lost = Image.avatars_lost
      @no_reverse_reference = Image.no_reverse_reference
      @backgrounds = Image.backgrounds
      @backgrounds_lost = Image.backgrounds_lost
      @orphan_records = Image.orphan_records
    end

    def nullify_orphan_records
      type = params[:type]
      case type
      when 'avatar', 'background'
        Dog.where(id: params[:dog]).update_all("#{type}_id": nil)
      else
        return false
      end
    end

    def fix_references
      images_to_purge = Image.where(id: Image.orphan_records)
      images_to_purge.each do |image|
        image.file.purge
        image.destroy
      end
      redirect_to collection_path, notice: t(:references_fixed)
    end

  end

end
