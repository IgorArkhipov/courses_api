# frozen_string_literal: true

class UserResource < JSONAPI::Resource
  attributes :name, :email, :is_author

  has_many :authored_courses, class_name: 'Course', relation_name: :authored_courses
  has_many :courses, relation_name: :courses
end
