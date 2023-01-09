# frozen_string_literal: true

class CreateTalentCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :talent_courses do |t|
      t.integer :talent_id
      t.integer :course_id

      t.timestamps
    end

    add_index :talent_courses, :talent_id
    add_index :talent_courses, :course_id
  end
end
