require 'sinatra'
require 'rack/cors'

require 'resque-data'

#Resque::Data::Config.default_redis = "localhost:6379/"
#Resque::Data::Config.multi_namespace = false
#Resque::Data::Config.multi_redis = false

use Rack::Cors do |config|
  config.allow do |allow|
    allow.origins '*'
    allow.resource '/', :headers => :any
  end
end

run Resque::Data::Server
