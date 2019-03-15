require 'rails_helper'

RSpec.describe Dog, type: :model do
  subject { create(:dog) }
  let(:dog_with_pictures) { create(:dog, :with_pictures_uploaded, images_count: 5) }

  context 'when creating' do
    it { is_expected.to validate_presence_of :nickname }
    it { is_expected.to validate_presence_of :fullname }
    it { is_expected.to validate_presence_of :birthdate }
    it { is_expected.to validate_presence_of :about }
    it { is_expected.to validate_presence_of :award_point }
    it { is_expected.to validate_inclusion_of(:rip).in_array([true, false]) }
    it { is_expected.to define_enum_for(:gender).with_values(male: 1, female: 0) }
    it 'should have avatar' do
      subject.avatar = create(:image, dog: subject)
      subject.avatar.file.attach(FilesTestHelper.jpg)
      expect(subject.avatar.file).to be_attached
    end
    it 'should have pictures' do
      expect(dog_with_pictures.pictures.count).to eq(5)
    end
    it 'should have background' do
      expect(dog_with_pictures.background.file).to be_attached
    end
  end

  context 'when kid added to' do
    # it { expect(awards).to be >= 1 }
    # it { expect(spouces).to be >= 1 }
    # it { expect(kids).to be >= 1 }
  end
end