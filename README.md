# Ruby Queue Good Job (Autoscale.app)

Produces [Good Job] queue metrics for the [Autoscale.app] [Agent].

## Installation

Add the gem to your `Gemfile`:

    bundle add autoscale-queue-good_job --version "~> 0"

## Usage

The following `latency` function can be used to determine the latency of the specified queue(s).

The return value of `latency` (`Integer`) is used in conjunction with the [Agent] gem to make metrics available to [Autoscale.app] for the purpose of autoscaling [Good Job] worker processes.

```rb
# Latency across all queues
Autoscale::Queue::GoodJob.latency

# Latency for a single queue
Autoscale::Queue::GoodJob.latency(:default)

# Latency across multiple queues
Autoscale::Queue::GoodJob.latency(:default, :high, :low)

# Latency for a priority level across all queues
Autoscale::Queue::GoodJob.latency(priority: 5)

# Latency for a priority level range across all queues
Autoscale::Queue::GoodJob.latency(priority: 1..3)

# Latency for a priority level scoped to a single queue
Autoscale::Queue::GoodJob.latency(:default, priority: 5)
```

## Development

Prepare environment:

    bin/setup

See Rake for relevant tasks:

    bin/rake -T

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/autoscale-app/ruby-queue-good_job

[Autoscale.app]: https://autoscale.app
[Agent]: https://github.com/autoscale-app/ruby-agent
[Good Job]: https://github.com/bensheldon/good_job
