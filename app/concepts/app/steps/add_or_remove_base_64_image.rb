# adds an image on base 64 basis
class App::Steps::AddOrRemoveBase64Image < App::Steps::Base
  extend Uber::Callable

  require "image_processing/mini_magick"

  def self.call(options, params:, model:, **)
    return true if !params['file'].present?

    if params['file'] == 'purge'
      model.image.purge
    else
      str = params['file'].split(",")[1]
      to_decode = nil

      if str
        to_decode = str
      else
        to_decode = params['file']
      end

      blob = Base64.decode64(to_decode)
      image = MiniMagick::Image.read(blob)
      image.quality(90)
      if params['resize'] || params[:resize]
        image.resize('500x500')
      end
      f = File.open(image.path)

      model.image.attach(io: f, filename: SecureRandom.hex)
    end
    true
  end
end
