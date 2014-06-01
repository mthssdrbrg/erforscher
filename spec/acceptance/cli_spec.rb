# encoding: utf-8

require 'spec_helper'

describe 'bin/erforscher' do
  let :io do
    StringIO.new
  end

  let :ec2 do
    FakeEc2.new(Resource.instances)
  end

  let :config do
    {'hostsfile_path' => hostsfile.path}
  end

  let :hostsfile do
    Tempfile.new('etc-hosts')
  end

  let :config_file do
    Tempfile.new('config.yml')
  end

  before do
    Aws::EC2.stub(:new).and_return(ec2)
  end

  let :new_hostsfile do
    File.read(config['hostsfile_path'])
  end

  let :argv do
    []
  end

  let :run_command do
    Erforscher::Cli.run(%W[--config #{config_file.path}] + argv, io)
  end

  let :code do
    run_command
  end

  before do
    config_file.puts(YAML.dump(config))
    config_file.rewind
  end

  after do
    hostsfile.delete
    config_file.delete
  end

  context 'when given --help or -h' do
    it 'returns 2 and prints usage' do
      code = Erforscher::Cli.run(%w[-h], io)
      expect(code).to eq(2)
      expect(io.string).to include 'Usage:'

      io.rewind

      code = Erforscher::Cli.run(%w[--help], io)
      expect(code).to eq(2)
      expect(io.string).to include 'Usage:'
    end
  end

  context 'when given --config' do
    context 'and configuration file exists' do
      let :config do
        {
          'hostsfile_path' => hostsfile.path,
          'tags' => [{
            'Environment' => 'test',
            'Created-By' => 'no-one'
          }]
        }
      end

      before do
        run_command
      end

      it 'returns 0' do
        expect(code).to eq(0)
      end

      it 'prints nothing' do
        expect(io.string).to be_empty
      end

      it 'uses configuration from given path' do
        expect(new_hostsfile).to include("instance-001\t10.0.0.1")
      end
    end

    context 'and configuration file does not exist' do
      it 'returns 1' do
        code = Erforscher::Cli.run(%w[--config non-existing-file.yml], io)
        expect(code).to eq(1)
      end

      it 'prints an error message and usage' do
        Erforscher::Cli.run(%w[--config non-existing-file.yml], io)

        expect(io.string).to include('Could not find configuration file')
        expect(io.string).to include('Usage:')
      end
    end
  end

  context 'when given -T or --tags' do
    let :argv do
      %w[-T Environment=Cli]
    end

    before do
      run_command
    end

    it 'filters using given tags' do
      expect(new_hostsfile).to include("instance-003\t10.0.0.3")
    end
  end

  context 'when given -N or --name' do
    let :argv do
      %w[-T Environment=other -N NameTag]
    end

    before do
      run_command
    end

    it 'uses given `tag` for parsing hostnames' do
      expect(new_hostsfile).to include("instance-004\t10.0.0.4")
    end
  end
end
