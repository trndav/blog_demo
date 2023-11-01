# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# https://guides.rubyonrails.org/debugging_rails_applications.html

Rails.logger = Logger.new("log/#{Rails.env}.log")
Rails.logger.level = Logger::INFO
# or Rails.logger.level = 0
Rails.logger.datetime_format = '%d-%m-%Y %H:%M:%S'
Rails.logger.formatter = proc do |severity, datetime, progname, msg|
    "#{datetime}|#{severity}|#{progname}|#{msg}\n"
end
Rails.logger.debug("Environment: #{Rails.env}") do 
    "Started application"
end