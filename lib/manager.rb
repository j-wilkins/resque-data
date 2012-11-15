class RedisManager

  def initialize(redi = [])
    @redi = Hash[redi.map {|r| [r, ResqueFetcher.new(redis: r)]}]
    @timestamps = Hash.new
  end

  def for(host = 'redis://localhost:6379')
    (@redi[host] ||= new_redis(host)).tap do
      @timestamps[host] = Time.now
    end
  end

  def new_redis(host)
    prune if needs_pruning?

    ResqueFetcher.new(redis: host)
  end

  def needs_pruning?
    @redi.length >= 20
  end

  def prune
    oldest = @timestamps.sort_by {|host, time| time}.first.first
    puts "deleting #{oldest}"
    @timestamps.delete(oldest)
    @redi.delete(oldest)
  end

  def to_json
    @redi.to_json
  end

end
