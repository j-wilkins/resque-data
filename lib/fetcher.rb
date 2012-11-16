class ResqueFetcher

  def initialize(params)
    (params[:redis] || 'redis://localhost:6379').tap do |r|
      @connection, @default_namespace = parse_redis(r)
    end

    @default_namespace ||= params[:namespace] || :resque
  end

  def fetch
    fetch_for(@default_namespace)
  end

  def fetch_for(ns)
    using_namespace(ns) do
      queue_counts.merge(failed_count).merge(worker_counts)
    end
  end

  def queue_counts
    {queues: redis.smembers(:queues).map {|q| {queue: q, count: redis.llen("queue:#{q}")}}}
  end

  def failed_count
    {failed: redis.llen(:failed)}
  end

  def worker_counts
    workers = redis.smembers(:workers)
    working = 0
    workers.each {|w| working += 1 if redis.exists("worker:#{w}")}
    {working: working, workers: workers.length}
  end

  def worker_stats
    Hash[redis.smembers(:workers).map do |w|
      [w, redis.exists("worker:#{w}") ? :working : :idle]
    end]
  end

  def using_namespace(ns)
    redis.namespace = ns
    ret = yield
  ensure
    redis.namespace = @default_namespace
    ret
  end

  def redis
    @redis ||= Redis::Namespace.new(@default_namespace, redis: @connection)
  end

  private

  def parse_redis(server)
    case server
    when String
      if server['redis://']
        redis = Redis.new(:url => server, :thread_safe => true)
      else
        server, namespace = server.split('/', 2)
        host, port, db = server.split(':')
        redis = Redis.new(:host => host, :port => port,
          :thread_safe => true, :db => db)
      end
      [redis, namespace]
    when Redis::Namespace
      [server.redis, server.namespace]
    else
      [server, nil]
    end
  end

end
