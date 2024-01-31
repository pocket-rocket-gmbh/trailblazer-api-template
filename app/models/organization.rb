class Organization < ApplicationRecord
  include ActiveStorageSupport::SupportForBase64
  has_one_base64_attached :image

  has_many :customers
  has_many :users

  enum status: {
    inactive: 0,
    active: 1,
    initialization: 2
  }

  def image_url
    if image.attached?
      Rails.application.routes.url_helpers.url_for(image)
    end
  end
end
