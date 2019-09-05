class GalleryController < ApplicationController
  def index
    @gallery = Image.all
    @background = Preference.background
  end
end
