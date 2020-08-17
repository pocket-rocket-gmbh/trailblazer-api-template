class Organization < ApplicationRecord
  enum status: {
    inactive: 0,
    active: 1,
    initialization: 2
  }
end
