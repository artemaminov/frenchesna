FactoryBot.define do

  factory :dog do
    name { Faker::Name.name_with_middle }
    nickname { Faker::Name.first_name }
    birthdate { Faker::Date.birthday(1, 10) }
    about { Faker::Lorem.paragraph(2) }
    award_point { Faker::Number.between(1, 5) }
    rip { Faker::Boolean.boolean }
    gender { Faker::Number.between(0, 1) }

    trait :with_pictures_uploaded do
      transient {
        images_count { 1 }
      }

      after(:create) do |dog, evaluator|
        build_list(:image, evaluator.images_count, dog: dog) do #Why order is empty
          file_path = Rails.root.join('spec', 'support', 'assets', 'dog-thumb.jpg')
          file = fixture_file_upload(file_path, 'image/jpg')
          byebug
          dog.pictures.create.file.attach(file)
        end
      end
    end

  end
end