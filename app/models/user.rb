# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  is_author  :boolean          default(FALSE)
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#  index_users_on_name   (name)
#
class User < ApplicationRecord
  has_many :authored_courses, class_name: 'Course', foreign_key: 'author_id',
                              inverse_of: :author, dependent: nil
  has_many :talent_courses, foreign_key: 'talent_id', inverse_of: :talent, dependent: :destroy
  has_many :courses, through: :talent_courses

  validates :name, presence: true, format: { with: /\A[a-zA-Z\s]+\z/ },
                   length: { maximum: 255 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }
  validates :is_author, inclusion: { in: [true, false] }

  before_destroy :transfer_courses_to_another_author_or_delete, if: :is_author

  private

  def transfer_courses_to_another_author_or_delete
    new_author = User.where.not(id: id).find_by(is_author: true)
    authored_courses.destroy_all && return unless new_author

    authored_courses.find_each { |course| course.update(author: new_author) }
  end
end
