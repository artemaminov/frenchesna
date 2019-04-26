require 'rails_helper'

RSpec.feature "Show page", type: :feature do
  context "displays blocks" do
    let(:dog) { create :dog }

    it "dogs name" do
      visit dog_path dog.id
      within ".content .main" do
        expect(page).to have_text(dog.nickname)
      end
    end

  end
end
