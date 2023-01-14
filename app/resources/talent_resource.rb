# frozen_string_literal: true

class TalentResource < JSONAPI::Resource
  attributes :name, :email
  model_name 'User'
  model_hint model: User, resource: :talent

  has_many :courses, relation_name: :courses
end
