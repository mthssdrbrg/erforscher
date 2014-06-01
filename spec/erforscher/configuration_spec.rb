# encoding: utf-8

require 'spec_helper'

module Erforscher
  describe Configuration do
    let :configuration do
      described_class.new(cli_options, file)
    end

    let :file do
      double(:file)
    end

    let :cli_options do
      {}
    end

    before do
      @home = ENV['HOME']
      ENV['HOME'] = '/fake/home'
    end

    before do
      file.stub(:exist?)
    end

    after do
      ENV['HOME'] = @home
    end

    describe '#get' do
      context 'when given path to a configuration file' do
        context 'that exist' do
          let :config do
            {'name_tag' => 'ConfigFileName'}
          end

          let :cli_options do
            {'config_path' => 'this-is-a-config.yml'}
          end

          before do
            file.stub(:exist?).with('this-is-a-config.yml').and_return(true)
            file.stub(:read).with('this-is-a-config.yml').and_return(YAML.dump(config))
          end

          it 'uses configuration from path' do
            conf = configuration.get
            expect(conf['name_tag']).to eq('ConfigFileName')
          end
        end

        context 'that does not exist' do
          let :cli_options do
            {'config_path' => 'this-should-not-exist.yml'}
          end

          it 'raises an error' do
            expect { configuration.get }.to raise_error
          end
        end
      end

      context 'when not given path to a configuration file' do
        context 'and $HOME/.erforscher.yml exist' do
          let :config do
            {'name_tag' => 'HomeName'}
          end

          before do
            file.stub(:exist?).with('/fake/home/.erforscher.yml').and_return(true)
            file.stub(:read).with('/fake/home/.erforscher.yml').and_return(YAML.dump(config))
          end

          it 'uses it' do
            conf = configuration.get
            expect(conf['name_tag']).to eq('HomeName')
          end
        end

        context 'and $HOME/.erforscher.yml does not exist' do
          context 'and /etc/erforscher.yml exist' do
            let :config do
              {'name_tag' => 'EtcName'}
            end

            before do
              file.stub(:exist?).with('/etc/erforscher.yml').and_return(true)
              file.stub(:read).with('/etc/erforscher.yml').and_return(YAML.dump(config))
            end

            it 'uses it' do
              conf = configuration.get
              expect(conf['name_tag']).to eq('EtcName')
            end
          end

          context 'and /etc/erforscher.yml does not exist' do
            it 'uses default configuration' do
              conf = configuration.get
              expect(conf).to eq({
                'name_tag' => 'Name',
                'hostsfile_path' => '/etc/hosts',
                'tags' => []
              })
            end
          end
        end
      end
    end
  end
end
