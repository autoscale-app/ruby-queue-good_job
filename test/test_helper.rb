ENV["RAILS_ENV"] = "test"
require_relative "app/config/environment"
require "rails/test_help"

Rails.application.config.good_job.execution_mode = :external

class ActiveSupport::TestCase
  parallelize workers: :number_of_processors
  setup { travel_to Time.utc(2000) }
end
