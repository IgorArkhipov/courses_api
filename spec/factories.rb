# frozen_string_literal: true

FactoryBot.define do
  factory :author, class: 'User' do
    name { Faker::Name.unique.first_name }
    email { Faker::Internet.email(name: name) }
    is_author { true }
  end

  factory :talent, class: 'User' do
    name { Faker::Name.unique.first_name }
    email { Faker::Internet.email(name: name) }
    is_author { false }
  end

  factory :course do
    title { Faker::Lorem.sentence }
    author
  end

  factory :talent_course do
    talent
    course
  end
end
