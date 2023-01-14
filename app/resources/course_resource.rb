# frozen_string_literal: true

class CourseResource < JSONAPI::Resource
  attributes :title

  has_one :author
  has_many :talents
end
