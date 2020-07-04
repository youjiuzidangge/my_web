class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def render_success_data(message, code = 200, data = {})
    render_json_data(200, message, code, data)
  end

  def render_error_msg(message, code = 400)
    render_json_data(400, message || '请求失败', -1)
  end

  private

  def render_json_data(status, message, code, data = {})
    json        = { code: code, msg: message }
    json[:data] = data unless data.blank?
    render json: json, status: status
  end
end
