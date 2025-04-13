class Contract < ApplicationRecord
  belongs_to :user
  has_one :company_contract, dependent: :destroy
  has_one :individual_contract, dependent: :destroy
  has_one_attached :pdf

  validates :status, presence: true, inclusion: { in: %w[draft active completed cancelled accepted] }
  validates :user_id, presence: true

  accepts_nested_attributes_for :company_contract
  accepts_nested_attributes_for :individual_contract
end
