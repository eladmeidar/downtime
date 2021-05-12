class Api::V1::BaseController < Api::BaseController

  def set_api_version
    response.set_header('X-API-VERSION', '1.0')
  end
end
