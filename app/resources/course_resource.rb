# frozen_string_literal: true

class CourseResource < JSONAPI::Resource
  attributes :title

  has_one :author, class_name: 'User'
  has_many :talents, class_name: 'User', relation_name: :talents
end
