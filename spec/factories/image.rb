FactoryBot.define do

  factory :image do
    dog { nil }
    file { FilesTestHelper.jpg }
    # order { Faker::Number.between(0, 10) }
    sequence :order
  end

end