require 'factory_bot_rails'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

# byebug
FactoryBot.create_list(:dog, 5)
# Dog.create!(fullname: Faker::Name.name_with_middle, nickname: Faker::Name.first_name, birthdate: Faker::Date.birthday(1, 10), about: Faker::Lorem.paragraph(2), award_point: Faker::Number.between(1, 5), rip: Faker::Boolean.boolean, gender: Faker::Number.between(0, 1), puppy: Faker::Boolean.boolean)