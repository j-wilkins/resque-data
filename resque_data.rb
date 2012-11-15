require 'sinatra'
require 'json'
require 'redis/namespace'
require './lib/fetcher'
require './lib/manager'

class ResqueData < Sinatra::Application

  configure do
    $redis = RedisManager.new
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
