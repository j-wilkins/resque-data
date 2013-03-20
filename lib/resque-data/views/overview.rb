class Resque::Data::Views::Overview
  include Resque::Data::RedisHelpers

  attr_accessor :namespace

  def initialize(ns = nil)
    @namespace = ns || Resque.redis.namespace
  end

  def render
    Hash.new.tap do |result|
      temporary_namespace(namespace) do
        result[:queues] = Hash.new
        queue_names.each do |queue_name|
          result[:queues][queue_name] = queue_size(queue_name)
        end
        result[:failed] = failed_queue_size('failed')

        result[:workers] = Hash.new
        sorted_worker_jobs.each do |worker, job|
          host, pid, queues = worker.to_s.split(':')

          "#{host}:#{pid}".tap do |worker_name|
            result[:workers][worker_name] = {state: worker.state}
            if job[:queue]
              result[:workers][worker_name][:processing] = {
                :class => job['payload']['class'],
                started_at: job['run_at']
              }
            end
          end

        end

      end # => temporary_ns
    end # => Hash.new
  end # => render

  def as_json
    render
  end

  def to_json
    as_json.to_json
  end
end
