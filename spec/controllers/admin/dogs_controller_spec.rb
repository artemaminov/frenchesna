require 'rails_helper'

RSpec.describe Admin::DogsController, type: :controller do

  render_views

  let(:adminuser) { create :admin_user }
  let(:dog) { create :dog }
  # let(:page) { Capybara::Node::Simple.new(response.body) }

  before(:each) {
    sign_in adminuser
  }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
    it "contains dogs info" do
      dog
      get :index
      expect(response.body).to have_content(dog.fullname)
      expect(response.body).to have_content(dog.nickname)
      expect(response.body).to have_content(dog.award_point)
      expect(response.body).to have_content(dog.mother)
      expect(response.body).to have_content(dog.father)
      expect(response.body).to have_content(dog.birthdate)
      expect(response.body).to have_content(dog.gender)
      expect(response.body).to have_content(dog.rip)
      expect(response.body).to have_content(dog.about)
    end
  end

  # describe "GET #create" do
  #   it "returns http success" do
  #     post :create
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET #new" do
  #   it "returns http success" do
  #     get :new
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET #edit" do
  #   it "returns http success" do
  #     get :edit, params: { id: dog.id }
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET #show" do
  #   it "returns http success" do
  #     get :show, params: { id: dog.id }
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET #update" do
  #   it "returns http success" do
  #     patch :update, params: { id: dog.id }
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET #destroy" do
  #   it "returns http success" do
  #     delete :destroy, params: { id: dog.id }
  #     expect(response).to have_http_status(:success)
  #   end
  # end

end
