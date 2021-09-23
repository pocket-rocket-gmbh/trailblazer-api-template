class Organization < ApplicationRecord
  has_many :customers
  has_many :users

  enum status: {
    inactive: 0,
    active: 1,
    initialization: 2
  }
end
