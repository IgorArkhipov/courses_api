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
require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it 'requires a name' do
      user = described_class.new(name: '')
      expect(user).to be_invalid
    end

    it 'requires an email' do
      user = described_class.new(email: '')
      expect(user).to be_invalid
    end

    it 'requires a unique email' do
      described_class.create(name: 'John', email: 'john@example.com')
      user2 = described_class.new(name: 'Jane', email: 'john@example.com')
      expect(user2).to be_invalid
    end

    it 'allows an author to have no authored course' do
      user = described_class.new(name: 'John', email: 'john@example.com', is_author: true)
      expect(user).to be_valid
    end
  end

  describe 'associations' do
    it 'has many authored_courses' do
      user = described_class.new
      expect(user).to respond_to(:authored_courses)
    end

    it 'has many courses through talent_courses' do
      user = described_class.new
      expect(user).to respond_to(:courses)
    end

    it 'has many talent_courses' do
      user = described_class.new
      expect(user).to respond_to(:talent_courses)
    end
  end

  describe 'successful cases' do
    it 'creates a valid user with a name and email' do
      user = described_class.new(name: 'John', email: 'john@example.com')
      expect(user).to be_valid
    end

    it 'creates a valid user who is not author' do
      user = described_class.new(name: 'John', email: 'john@example.com')
      expect(user.is_author).to be(false)
    end

    it 'creates a valid author with a name, email and one authored course' do
      user = described_class.new(name: 'John', email: 'john@example.com', is_author: true)
      user.authored_courses.build(title: 'Ruby on Rails')
      expect(user).to be_valid
    end

    it 'transfers the course to another author before destroying the original author' do
      user1 = described_class.create(name: 'John', email: 'john@example.com', is_author: true)
      user2 = described_class.create(name: 'Jane', email: 'jane@example.com', is_author: true)
      Course.create(title: 'Ruby on Rails 6', author: user1)
      Course.create(title: 'Ruby on Rails 7', author: user2) && user1.destroy

      expect(user2.reload.authored_courses.count).to eq(2)
    end

    it 'deletes the authored course before destroying the original author' do
      user1 = described_class.create(name: 'John', email: 'john@example.com', is_author: true)
      course1 = Course.create(title: 'Ruby on Rails 6', author: user1)
      user1.destroy

      expect(Course.find_by(id: course1.id)).to be_nil
    end
  end
end
