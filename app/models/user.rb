class User < ApplicationRecord
  PARAMS = [:name, :email, :password]

  validates :email, presence: true, uniqueness: true, format: { with: /\A\S+@.+\.\S+\z/ }
  validates :name, :password_digest, presence: true

  has_secure_password

  has_many :videos, dependent: :destroy
end
