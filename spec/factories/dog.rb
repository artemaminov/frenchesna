FactoryBot.define do

  factory :dog do
    fullname { Faker::Name.name_with_middle }
    nickname { Faker::Name.first_name }
    birthdate { Faker::Date.birthday(1, 10) }
    about { Faker::Lorem.paragraph(2) }
    award_point { Faker::Number.between(1, 5) }
    rip { Faker::Boolean.boolean }
    gender { Faker::Number.between(0, 1) }
    puppy { Faker::Boolean.boolean }

    # trait :with_avatar do
    #   after(:create) do |dog|
    #     dog.avatar = create(:image, dog: dog)
    #     dog.avatar.file.attach(FilesTestHelper.jpg)
    #   end
    # end

    trait :with_pictures_uploaded do
      transient {
        images_count { 1 }
      }

      after(:create) do |dog, evaluator|
        build_list(:image, evaluator.images_count, dog: dog) do #Why order is empty
          dog.pictures.create.file.attach(FilesTestHelper.jpg)
          dog.background = dog.pictures.first
        end
      end

    end

  end
  
end