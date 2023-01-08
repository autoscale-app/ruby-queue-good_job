require "test_helper"

class LatencyTest < ActiveSupport::TestCase
  test "no latency" do
    WorkJob.set(queue: "default").perform_later
    assert_equal 0, Autoscale::Queue::GoodJob.latency("default")
  end

  test "3 second latency" do
    WorkJob.set(queue: "default").perform_later
    travel 3.second
    assert_equal 3, Autoscale::Queue::GoodJob.latency("default")
  end

  test "3 second latency between the two queues" do
    WorkJob.set(queue: "default").perform_later
    travel 1.seconds
    WorkJob.set(queue: "other").perform_later
    travel 2.second
    assert_equal 3, Autoscale::Queue::GoodJob.latency # implicit all queues
    assert_equal 3, Autoscale::Queue::GoodJob.latency("default", "other")
  end

  test "3 second latency by priority" do
    WorkJob.set(priority: 5).perform_later
    travel 3.second
    assert_equal 0, Autoscale::Queue::GoodJob.latency(priority: 3)
    assert_equal 3, Autoscale::Queue::GoodJob.latency(priority: 4..6)
  end

  test "exclude jobs scheduled to run in the future" do
    WorkJob.set(queue: "default", wait: 1.minute).perform_later
    travel 3.second
    assert_equal 0, Autoscale::Queue::GoodJob.latency
  end

  test "include scheduled jobs that are ready to run" do
    WorkJob.set(queue: "default", wait_until: 1.minute.ago).perform_later
    assert_equal 60, Autoscale::Queue::GoodJob.latency
  end

  test "exclude finished jobs" do
    WorkJob.set(queue: "default").perform_later
    GoodJob::Job.update_all(finished_at: Time.now)
    travel 3.seconds
    assert_equal 0, Autoscale::Queue::GoodJob.latency
  end
end
