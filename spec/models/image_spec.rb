require 'rails_helper'

RSpec.describe Image, type: :model do
  let(:orphan_images) { create(:image) }

  context "Fixing broken records" do
    it 'counts orphan records' do
      expect(Image.orphan_records).to eq(orphan_images.to_a.length)
    end
  end

end
