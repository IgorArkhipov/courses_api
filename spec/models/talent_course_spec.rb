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
require 'rails_helper'

RSpec.describe TalentCourse do
  describe 'validations' do
    it 'requires a course_id' do
      talent_course = described_class.new(talent_id: 1)
      expect(talent_course).to be_invalid
    end

    it 'requires a talent_id' do
      talent_course = described_class.new(course_id: 1)
      expect(talent_course).to be_invalid
    end
  end

  describe 'associations' do
    it 'belongs to a talent' do
      talent_course = described_class.new
      expect(talent_course).to respond_to(:talent)
    end

    it 'belongs to a course' do
      talent_course = described_class.new
      expect(talent_course).to respond_to(:course)
    end
  end

  describe 'successful cases' do
    it 'creates a valid talent_course association with a course' do
      author = User.create(name: 'John', email: 'john@example.com', is_author: true)
      talent = User.create(name: 'Jane', email: 'jane@example.com', is_author: false)
      course = Course.create(title: 'Ruby on Rails', author: author)
      described_class.create(course: course, talent: talent)
      expect(talent.courses.first).to eq(course)
    end

    it 'creates a valid talent_course association with a talent' do
      author = User.create(name: 'John', email: 'john@example.com', is_author: true)
      talent = User.create(name: 'Jane', email: 'jane@example.com', is_author: false)
      course = Course.create(title: 'Ruby on Rails', author: author)
      described_class.create(course: course, talent: talent)
      expect(course.talents.first).to eq(talent)
    end
  end
end
