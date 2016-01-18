class Movie < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :genre, :year
  validates :title, uniqueness: {:case_sensitive => false}, presence: true
end
