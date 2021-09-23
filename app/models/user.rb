class User < ApplicationRecord
  include ActiveStorageSupport::SupportForBase64

  has_secure_password validations: false
  has_one_base64_attached :profile_image

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

  def name
    "#{firstname} #{lastname}"
  end

  def profile_image_url
    if profile_image.attached?
      # Rails.application.routes.url_for(profile_image)
      # profile_image.service_url
      Rails.application.routes.url_helpers.url_for(profile_image)
    end
  end

  def permissions
    App::AccessPrivileges.send(role.to_sym)
  end
end
