# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
require File.expand_path(File.dirname(__FILE__) + "/environment")

# Example:
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end

set :output, error: '/var/www/my_web/shared/log/cron_error.log',
             standard: '/var/www/my_web/shared/log/cron_standard.log'

# env :PATH, ENV['PATH']

every 3.minutes do
  rake "books:cancel_invalid_transaction"
end

every 5.minutes do
  rake "books:refund_to_users"
end

every 10.minutes do
  rake "books:calculate_incomes"
end