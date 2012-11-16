require 'resque-data/version'
require "resque-data/config"

require "resque-data/fetcher"
require "resque-data/manager"

module Resque
  module Data

    autoload :Server, 'resque-data/server'

  end
end
