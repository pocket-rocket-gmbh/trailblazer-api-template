class User < ApplicationRecord
  has_secure_password

  belongs_to :organization

  enum role: {
    root: 0,
    user: 1,
    admin: 2,
    platform_admin: 3
  }, _suffix: true

  enum status: {
    unconfirmed: 0,
    confirmed: 1,
    disabled: 2
  }
end
