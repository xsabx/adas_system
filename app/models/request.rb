class Request < ApplicationRecord
  belongs_to :user
  has_one :technical_request, dependent: :destroy
  has_one :course_content_request, dependent: :destroy
  has_one :response, dependent: :destroy

  accepts_nested_attributes_for :technical_request
  accepts_nested_attributes_for :course_content_request

  enum request_type: { technical: "technical", course: "course" }
end
