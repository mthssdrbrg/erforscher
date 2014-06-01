# encoding: utf-8

module Erforscher
  class Cli
    def self.run(argv, io)
      new.run(argv, io)
    end

    def run(argv, io)
      config = parse_options(argv)
      if config['print_usage']
        io.puts(@parser)
        2
      else
        Runner.run(config)
      end
    rescue => e
      io.puts(%(#{e.message} (#{e.class.name})))
      io.puts(@parser)
      1
    end

    private

    def defaults
      {
        'name_tag' => 'Name',
        'hostsfile_path' => '/etc/hosts',
        'tags' => []
      }
    end

    def parse_options(argv, cli={})
      @parser = OptionParser.new do |parser|
        parser.on('-c', '--config=PATH', 'Path to configuration file') do |config_path|
          cli['config_path'] = config_path
        end

        parser.on('-T', '--tags=LIST', Array, 'List of `tag` key-value pairs') do |tags|
          cli['tags'] = [parse_tags(tags)]
        end

        parser.on('-N', '--name=TAG', '"Name" `tag`') do |name_tag|
          cli['name_tag'] = name_tag
        end

        parser.on('-h', '--help', 'You\'re looking at it') do
          cli['print_usage'] = true
        end
      end
      @parser.parse(argv)
      config = read_config(cli['config_path'])
      options = defaults.merge(config).merge(cli)
      options
    end

    def read_config(path=nil)
      if path
        unless File.exist?(path)
          raise 'Could not find configuration file %s' % path
        end
        YAML.load_file(path)
      else
        {}
      end
    end

    def parse_tags(keys_values)
      if keys_values.any? { |kv| kv.include?('=') }
        Hash[keys_values.map { |kv| kv.split('=') }]
      end
    end
  end
end
