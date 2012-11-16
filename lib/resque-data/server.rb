require 'sinatra'
require 'json'
require 'redis/namespace'

module Resque
  module Data
    class Server < Sinatra::Application

      configure do
        $redis ||= RedisManager.new(Resque::Data::Config.default_redis,
                                  Resque::Data::Config.multi_namespace,
                                  Resque::Data::Config.multi_redis)
      end

      before do
        content_type 'application/json'

      end

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
