class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :role, presence: true, inclusion: { in: %w[client worker] }
  validates :name, presence: true

  def client?
    role == 'client'
  end

  def worker?
    role == 'worker'
  end
end
