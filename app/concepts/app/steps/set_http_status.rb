# Sets http_status to 200
class App::Steps::SetHttpStatus < App::Steps::Base
  def self.call(ctx, status:, **)
    ctx['http_status'] = status
  end
end
