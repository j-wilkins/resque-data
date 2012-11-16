
module Resque
  module Data

    class Config
      def self.default_redis=(arg)
        Thread.current[:redis_data_default_redis] = arg
      end

      def self.default_redis
        Thread.current[:redis_data_default_redis].tap do |ans|
          return nil if ans.nil?
        end
      end

      def self.multi_namespace=(true_or_false)
        Thread.current[:redis_data_multi_namespace] = !!true_or_false
      end

      def self.multi_namespace
        Thread.current[:redis_data_multi_namespace].tap do |ans|
          return true if ans.nil?
        end
      end

      def self.multi_redis=(true_or_false)
        Thread.current[:redis_data_multi_redis] = !!true_or_false
      end

      def self.multi_redis
        Thread.current[:redis_data_multi_redis].tap do |ans|
          return true if ans.nil?
        end
      end

    end
  end
end
