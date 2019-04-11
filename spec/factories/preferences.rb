FactoryBot.define do
  factory :preference do

    after(:create) do |pref|
      pref.background.attach(FilesTestHelper.jpg)
    end
  end
end
