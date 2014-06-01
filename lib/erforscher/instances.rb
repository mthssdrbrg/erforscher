# encoding: utf-8

module Erforscher
  class Instances
    def initialize(ec2)
      @ec2 = ec2
    end

    def all
      instances_from(@ec2.describe_instances)
    end

    def with_tags(tags)
      filters = tags.map { |key, value| {name: %(tag:#{key}), values: [value]} }
      instances_from(@ec2.describe_instances(filters: filters))
    end

    private

    def instances_from(response)
      response.flat_map(&:reservations).flat_map(&:instances)
    end
  end
end
