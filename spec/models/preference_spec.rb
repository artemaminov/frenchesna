require 'rails_helper'

RSpec.describe Preference, type: :model do
  subject { create(:preference) }
  it "attaches home page background" do
    expect(subject.background).to be_attached
  end
end
