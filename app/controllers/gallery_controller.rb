class GalleryController < ApplicationController
  before_action :get_menu_items
  def index
    @gallery = Image.all
    @background = Preference.background
  end
end
