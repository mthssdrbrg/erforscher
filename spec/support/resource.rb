# encoding: utf-8

class Resource
  def self.instances
    @instances ||= begin
      path = File.expand_path(%(../../resources/instances.json), __FILE__)
      JSON.parse(File.read(path), symbolize_names: true)
    end
  end
end
