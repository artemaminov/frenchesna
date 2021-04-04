class ApplicationController < ActionController::Base
  def get_menu_items
    @dogs = Dog.adults.alive.sort_by_breed.sort_by_birth.sort_by_name
    @puppies = Dog.puppies.sort_by_breed.sort_by_birth.sort_by_name
  end
end
