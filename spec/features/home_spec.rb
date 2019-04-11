require 'rails_helper'

RSpec.feature "Home page", type: :feature do
  context "displays all blocks" do
    it "displays menu" do
      visit root_path
      within(".menu") do
        expect(page).to have_text(Dog.all[0].nickname)
      end
    end

    it "displays hello text" do
      visit root_path
      expect(page).to have_content(".hello")
    end
  end
end
