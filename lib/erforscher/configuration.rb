# encoding: utf-8

module Erforscher
  ConfigurationError = Class.new(ErforscherError)

  class Configuration
    def initialize(cli, file=File)
      @cli = cli
      @file = file
    end

    def get
      if (path = @cli.delete('config_path'))
        unless @file.exist?(path)
          raise ConfigurationError, 'Could not find any configuration file'
        end
        config = load_config(path)
      elsif @file.exist?(home_path)
        config = load_config(home_path)
      elsif @file.exist?(etc_path)
        config = load_config(etc_path)
      else
        config = {}
      end

      defaults.merge(config).merge(@cli)
    end

    private

    def load_config(path)
      YAML.load(@file.read(path))
    end

    def home_path
      File.join(ENV['HOME'], '.erforscher.yml')
    end

    def etc_path
      '/etc/erforscher.yml'
    end

    def defaults
      {
        'name_tag' => 'Name',
        'hostsfile_path' => '/etc/hosts',
        'tags' => []
      }
    end
  end
end
