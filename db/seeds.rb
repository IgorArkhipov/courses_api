# frozen_string_literal: true

# create sample authors
User.delete_all
4.times do |_|
  name = Faker::Name.unique.first_name
  User.create! name: name, email: Faker::Internet.email(name: name), is_author: true
end

# create sample courses
Course.delete_all
3.times do |_|
  Course.create! title: Faker::Lorem.sentence, author: User.find(User.pluck(:id).sample)
end

# create sample talents as course members
TalentCourse.delete_all # delete all relations between courses and talents
10.times do |_|
  course = Course.find(Course.pluck(:id).sample)
  name = Faker::Name.unique.first_name
  talent = User.create! name: name, email: Faker::Internet.email(name: name)
  TalentCourse.create!(talent_id: talent.id, course_id: course.id)
end
