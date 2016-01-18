class User < ActiveRecord::Base
  has_many :movies, dependent: :destroy
  validates :email, presence: true, :case_sensitive => false, uniqueness: true, format: { with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/ }
end
