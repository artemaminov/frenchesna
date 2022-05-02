class GalleryController < ApplicationController
  include Pagy::Backend

  before_action :get_menu_items
  def index
    @pagy, @gallery = pagy(Image.all)
    @background = Preference.background
  end
end
