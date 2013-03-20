module Resque::Data::RedisHelpers
  def redis
    Resque.redis
  end

  def temporary_namespace(ns)
    ns_save = Resque.redis.namespace
    Resque.redis.namespace = ns
    yield(Resque.redis)
  ensure
    Resque.redis.namespace = ns_save
  end

  def queue_names
    Resque.queues.sort_by(&:to_s)
  end

  def queue_size(name)
    Resque.size(name)
  end

  def failed_queue_names
    Resque::Failure.queues.sort_by(&:to_s)
  end

  def failed_queue_name(original_queue_name)
    "#{original_queue_name}_failed"
  end

  def failed_queue_size(queue_name)
    Resque::Failure.count#(queue_name)
  end

  def workers
    #@workers ||= Resque.workers
    Resque.workers
  end

  def jobs
    #@jobs ||= workers.map(&:job)
    workers.map(&:job)
  end

  def worker_jobs
    #@worker_jobs ||= workers.zip(jobs).reject { |w, j| w.idle? }
    workers.zip(jobs).reject { |w, j| w.idle? }
  end

  def sorted_worker_jobs
    #@sorted_worker_jobs ||= worker_jobs.sort_by { |w, j| j['run_at'] || '' }
    worker_jobs.sort_by { |w, j| j['run_at'] || '' }
  end
end
