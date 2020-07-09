FactoryBot.define do
  factory :preference do
    about { Faker::Lorem.paragraph 5 }

    after(:create) do |pref|
      pref.background.attach(FilesTestHelper.jpg)
    end
  end
end
