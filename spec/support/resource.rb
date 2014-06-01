# encoding: utf-8

class Resource
  TYPES = %i[instances]

  class << self
    def [](type)
      @resources ||= {}
      @resources[type] ||= JSON.parse(read_file(type), symbolize_names: true)
    end

    TYPES.each do |type|
      define_method(type) { self[type] }
    end

    private

    def read_file(type)
      path = File.expand_path("../../resources/#{type}.json", __FILE__)
      raise ArgumentError, "Unable to load #{path}" unless File.exists?(path)

      File.read(path)
    end
  end
end
