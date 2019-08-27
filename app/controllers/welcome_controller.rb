class WelcomeController < ApplicationController
  def index
    Rails.logger.info('*'*100)
    Rails.logger.info(request.headers['X-User-Id'])
    Rails.logger.info(request.headers['Host'])
  end
end
