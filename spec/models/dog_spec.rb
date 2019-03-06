require 'rails_helper'

RSpec.describe Dog, type: :model do
  subject { create(:dog) }
  let!(:mydog) { create(:dog, :with_pictures_uploaded, images_count: 10) }

  context 'when added' do
    it { is_expected.to validate_presence_of :nickname }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :birthdate }
    it { is_expected.to validate_presence_of :about }
    it { is_expected.to validate_presence_of :award_point }
    it { is_expected.to validate_presence_of :rip }
    it { is_expected.to define_enum_for(:gender) }
    it 'includes pictures' do
      byebug
      expect(mydog.pictures.count).to eq(10)
    end
    # it { expect(adult_dog.avatar).to be_attached }
    # it { expect(adult_dog.background).to be_attached }
  end

  context 'when kid added to' do
    # it { expect(awards).to be >= 1 }
    # it { expect(spouces).to be >= 1 }
    # it { expect(kids).to be >= 1 }
  end
end