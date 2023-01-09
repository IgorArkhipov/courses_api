# frozen_string_literal: true

# == Schema Information
#
# Table name: talent_courses
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :integer
#  talent_id  :integer
#
# Indexes
#
#  index_talent_courses_on_course_id  (course_id)
#  index_talent_courses_on_talent_id  (talent_id)
#
class TalentCourse < ApplicationRecord
  belongs_to :talent, class_name: 'User'
  belongs_to :course
end
