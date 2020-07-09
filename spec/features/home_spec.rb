require 'rails_helper'

RSpec.feature "Home page", type: :feature do
  context "displays blocks" do
    let!(:dogs) { create_list :dog, 5 }
    let!(:preferences) { create :preference }

    it "contains menu with alive dogs" do
      visit root_path
      within(".sidebar.left .menu") do
        expect(page).to have_text(Dog.alive.first.fullname)
      end
    end
  end
end
