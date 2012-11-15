require 'rack/cors'
require './resque_data'

use Rack::Cors do |config|
  config.allow do |allow|
    allow.origins '*'
    allow.resource '/', :headers => :any
  end
end

run ResqueData
