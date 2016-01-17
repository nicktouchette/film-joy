class User < ActiveRecord::Base
  has_many :movies, dependent: :destroy
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/ }
end
