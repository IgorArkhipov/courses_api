# frozen_string_literal: true

class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :title, null: false
      t.integer :author_id
      t.index :title

      t.timestamps
    end
  end
end
