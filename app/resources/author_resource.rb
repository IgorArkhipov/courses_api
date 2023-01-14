# frozen_string_literal: true

class AuthorResource < JSONAPI::Resource
  attributes :name, :email, :is_author
  model_name 'User'
  model_hint model: User, resource: :author

  has_many :authored_courses, class_name: 'Course', relation_name: :authored_courses

  before_replace_fields :set_is_author

  def set_is_author
    @model.is_author = true
  end

  def fetchable_fields
    super - [:is_author]
  end

  def self.updatable_fields(_context)
    super - [:is_author]
  end

  def self.creatable_fields(_context)
    super - [:is_author]
  end

  def self.records(_options = {})
    User.where(is_author: true)
  end
end
