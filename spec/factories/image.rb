FactoryBot.define do
  factory :image do
    dog
    order { Faker::Number.between(0, 10) }
  end
end
