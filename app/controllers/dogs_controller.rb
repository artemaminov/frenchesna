class DogsController < ApplicationController
  before_action :get_menu_items

  def index
    @background = Preference.background
  end

  def show
    @dog = Dog.find(params[:id])
    @background = (@dog.background unless @dog.background.blank?) || Preference.background
  end

end
