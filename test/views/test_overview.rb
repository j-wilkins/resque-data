require 'test_helper'

class OverViewTest < Test::Unit::TestCase

  def setup
    Resque.redis = 'redis://localhost:6379/10'
    Resque.redis.flushdb
  end

  def teardown
    Resque.redis.flushdb
  end

  def test_render_empty
    @overview = Resque::Data::Views::Overview.new
    out = @overview.render
    assert_equal Hash.new, out[:queues]
    assert_equal 0, out[:failed]
  end

  def test_render_with_stuff
    Resque::Job.create(:queue1, 'SomeJob', [:arg])
    Resque::Job.create(:queue2, 'SomeJob', [:arg])
    Resque::Job.create(:queue2, 'SomeJob', [:arg])
    Resque::Failure::Redis.new(ArgumentError.new, :worker, :queue, :payload).save

    @overview = Resque::Data::Views::Overview.new
    p out = @overview.render

    assert_equal({'queue1' => 1, 'queue2' => 2}, out[:queues])
    assert_equal 1, out[:failed]
  end

end
