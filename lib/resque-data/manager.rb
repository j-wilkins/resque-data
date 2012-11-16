class Resque::Data::RedisManager

  def initialize(default_redis = nil, multi_namespace = true, multi_redis = true, redi = [])
    @default_redis = default_redis || 'redis://localhost:6379'

    @multi_namespace, @multi_redis = multi_namespace, multi_redis

    @redi = Hash[redi.map {|r| [r, new_redis(r)]}]
    @redi[@default_redis] = new_redis(@default_redis) if @redi[@default_redis].nil?

    @timestamps = Hash.new
  end

  def for(host = @default_redis)
    return @redi[@default_redis] unless @multi_redis

    (@redi[host] ||= new_redis(host)).tap do
      @timestamps[host] = Time.now
    end
  end

  def new_redis(host)
    prune if needs_pruning?

    Resque::Data::Fetcher.new(redis: host, multi_namespace: @multi_namespace)
  end

  def needs_pruning?
    @redi.length >= 20
  end

  def prune
    sorted = @timestamps.sort_by {|host, time| time}
    sorted.pop if sorted.first.first == @default_redis

    oldest = sorted.first.first
    puts "deleting #{oldest}"

    @timestamps.delete(oldest)
    @redi.delete(oldest)
  end

  def to_json
    @redi.to_json
  end

end
