# frozen_string_literal: true

# == Schema Information
#
# Table name: courses
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :integer
#
# Indexes
#
#  index_courses_on_title  (title)
#
class Course < ApplicationRecord
  belongs_to :author, class_name: 'User', inverse_of: :authored_courses
  has_many :talent_courses, dependent: :destroy
  has_many :talents, through: :talent_courses

  validates :title, presence: true, format: { with: /\A[a-zA-Z.,-:\d\s]+\z/ },
                    length: { maximum: 255 }

  after_create :set_author_flag

  private

  def set_author_flag
    author.update(is_author: true)
  end
end
