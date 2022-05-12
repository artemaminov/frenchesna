class DogsController < ApplicationController
  before_action :get_menu_items

  def index
    @background = Preference.background
  end

  def show
    @dog = Dog.find(params[:id])
    @background = (@dog.background.file.variant(crop: @dog.background.crop, resize: @dog.background.resize) unless @dog.background.blank?) || Preference.background
  end

end
