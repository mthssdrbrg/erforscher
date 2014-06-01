# encoding: utf-8

module Erforscher
  class Explorer
    def initialize(instances)
      @instances = instances
    end

    def discover(tag_combos)
      if tag_combos.empty?
        @instances.all
      else
        tag_combos.flat_map do |tags|
          @instances.with_tags(tags)
        end
      end
    end
  end
end
