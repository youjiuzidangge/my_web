class WelcomeController < ApplicationController
  def index
    Rails.logger.info('*'*100)
    Rails.logger.info(request.headers['X-User-Id'])
  end
end
