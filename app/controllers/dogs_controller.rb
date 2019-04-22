class DogsController < ApplicationController
  before_action :get_menu_items, :get_background

  def index
    @background = Preference.background
  end

  def show
    @dog = Dog.find(params[:id])
    @background = (@dog.background.file unless @dog.background.blank?) || Preference.background
  end

  private

  def get_menu_items
    @dogs = Dog.adults.alive
    @puppies = Dog.puppies.alive
  end

end
