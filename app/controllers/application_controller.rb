class ApplicationController < ActionController::Base
  def get_menu_items
    @dogs = Dog.adults.alive
    @puppies = Dog.puppies.alive
  end
end
