class DogsController < ApplicationController
  def index
    @dogs = Dog.adults.alive
    @puppies = Dog.puppies.alive
  end

  def show
    dog = Dog.find(params[:id])
  end
end
