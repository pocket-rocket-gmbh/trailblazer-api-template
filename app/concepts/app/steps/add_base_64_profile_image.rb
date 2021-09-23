# adds an image on base 64 basis
class App::Steps::AddBase64ProfileImage < App::Steps::Base
  extend Uber::Callable

  require "image_processing/mini_magick"

  def self.call(options, params:, model:, **)
    return true if !params['file'].present?

    str = params['file'].split(",")[1]
    blob = Base64.decode64(str)
    image = MiniMagick::Image.read(blob)
    image.resize('500x500')
    image.quality(90)
    f = File.open(image.path)

    model.profile_image.attach(io: f, filename: SecureRandom.hex)
    true
  end
end
