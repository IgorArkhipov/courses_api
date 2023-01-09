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
require 'rails_helper'

RSpec.describe Course do
  describe 'validations' do
    it 'requires a title' do
      course = described_class.new(title: '')
      expect(course).to be_invalid
    end

    it 'requires an author' do
      course = described_class.new(title: 'Intro to Ruby on Rails')
      expect(course).to be_invalid
    end
  end

  describe 'associations' do
    it 'has many talents through talent_courses' do
      course = described_class.new
      expect(course).to respond_to(:talents)
    end

    it 'has many talent_courses' do
      course = described_class.new
      expect(course).to respond_to(:talent_courses)
    end
  end

  describe 'successful cases' do
    it 'creates a valid course with a title and author' do
      author = User.create(name: 'John', email: 'john@example.com', is_author: true)
      course = described_class.new(title: 'Ruby on Rails', author: author)
      expect(course).to be_valid
    end

    it "sets the author's is_author field to true when a new course is created" do
      user = User.create(name: 'John', email: 'john@example.com', is_author: false)
      described_class.create(title: 'Ruby on Rails', author: user)
      expect(user.reload.is_author).to be(true)
    end
  end
end
