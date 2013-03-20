require 'sinatra'
require 'json'
require 'resque'
#require 'redis/namespace'
require 'resque-data/redis_helpers'
require 'resque-data/views'

module Resque
  module Data
    class Server < Sinatra::Application

      before do
        content_type 'application/json'
      end

      helpers Resque::Data::RedisHelpers

      include RedisHelpers

      get '/' do
        begin
          $redis.for(params['redis']).fetch_for(params['namespace']).to_json
        rescue Redis::CannotConnectError => boom
          status 404
          {message: 'The passed redis url was invalid'}.to_json
        end
      end

    end
  end
end
