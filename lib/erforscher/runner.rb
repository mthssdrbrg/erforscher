# encoding: utf-8

module Erforscher
  class Runner
    def initialize(config)
      @config = config
    end

    def self.run(config)
      new(config).run
    end

    def run
      explored = explorer.discover(@config['tags'])
      entries = explored.map { |ex| formatter.format(ex) }
      hostsfile.write(entries.sort)
      hostsfile.switch
    end

    private

    def formatter
      @formatter ||= Formatter.new(@config['name_tag'])
    end

    def current_hostsfile
      @current_hostsfile ||= File.open(@config['hostsfile_path'])
    end

    def working_file
      @working_file ||= Tempfile.new(%(erforscher-#{Time.now.to_i}))
    end

    def hostsfile
      @hostsfile ||= Hostsfile.new(current_hostsfile, working_file)
    end

    def explorer
      @explorer ||= Explorer.new(instances)
    end

    def instances
      @instances ||= Instances.new(ec2)
    end

    def ec2
      @ec2 ||= Aws::EC2.new(region: @config['region'])
    end
  end
end
