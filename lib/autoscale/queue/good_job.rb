require_relative "good_job/version"

module Autoscale
  module Queue
    module GoodJob
      def latency(*queues, priority: false)
        qry = ::GoodJob::Job.select("COALESCE(scheduled_at, created_at) AS run_at")
        qry = qry.where(queue_name: queues) unless queues.empty?
        qry = qry.where(priority: priority) unless priority == false
        age = qry.queued.order(:run_at).first.try(:run_at)
        age ? (Time.now - age).round : 0
      end

      module_function :latency
    end
  end
end
