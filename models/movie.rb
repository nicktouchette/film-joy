class Movie < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :genre, :year
  validates :title, uniqueness: true, presence: true, :case_sensitive => false
end
