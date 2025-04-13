class CreateCourseContentRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :course_content_requests do |t|
      t.references :request, null: false, foreign_key: true
      t.string :course
      t.string :category
      t.text :description

      t.timestamps
    end
  end
end
