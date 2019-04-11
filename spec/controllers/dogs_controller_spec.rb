require 'rails_helper'

RSpec.describe DogsController, type: :controller do

  render_views

  describe "GET #index" do
    let!(:dogs) { create_list :dog, 5, :with_pictures_uploaded }

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    # it "contains dogs info" do
    #   get :index
    #   expect(response.body).to have_content(dogs.each do |dog| dog.fullname end)
    # end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

end
