# encoding: utf-8

class FakeEc2
  def initialize(instances)
    @instances = instances.map do |instance|
      tags = instance.delete(:tags)
      tags = tags.map { |tag| OpenStruct.new(tag) }
      instance[:tags] = tags
      OpenStruct.new(instance)
    end
  end

  def describe_instances(opts={})
    filters = opts.fetch(:filters, []).dup
    instances = @instances.dup

    while filters.any? do
      filter = filters.shift
      key = filter[:name].split(':').last
      value = filter[:values].first

      instances = instances.select do |instance|
        instance.tags.any? do |tag|
          tag[:key] == key && tag[:value] == value
        end
      end
    end

    [FakeResponse.new(instances)]
  end

  private

  class FakeResponse
    def initialize(instances)
      @instances = instances
    end

    def reservations
      @instances.map { |instance| FakeReservation.new(instance) }
    end
  end

  class FakeReservation
    def initialize(instance)
      @instance = instance
    end

    def instances
      [@instance]
    end
  end
end
