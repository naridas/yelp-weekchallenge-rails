class Restaurant < ActiveRecord::Base
  has_many :reviews
  validates :name, length: { minimum: 3 }, uniqueness: true
  # validates_associated :reviews
end
