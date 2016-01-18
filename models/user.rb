class User < ActiveRecord::Base
  has_many :movies, dependent: :destroy
  validates :email, presence: true, uniqueness: {:case_sensitive => false}, format: { with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/ }
end
