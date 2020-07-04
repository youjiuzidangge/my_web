class ApplicationController < ActionController::Base
  def render_success_data(message, code = 200, data = {})
    render_json_data(code, message, code, data)
  end

  def render_error_msg(message, code = 400)
    render_json_data(code, message || '请求失败', code)
  end

  private

  def render_json_data(status, message, code, data = {})
    json        = { code: code, msg: message }
    json[:data] = data unless data.blank?
    render json: json, status: status
  end
end
