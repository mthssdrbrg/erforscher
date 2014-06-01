# encoding: utf-8

require 'spec_helper'

module Erforscher
  describe Formatter do
    let :formatter do
      described_class.new(name_tag)
    end

    let :name_tag do
      'Name'
    end

    let :instance do
      OpenStruct.new({
        tags: [
          {key: 'Name', value: 'hello-world-001.domain.com'}
        ],
        private_ip_address: '10.0.0.1',
        private_dns_name: 'private-dns-name',
      })
    end

    let :formatted do
      formatter.format(instance)
    end

    context 'when instance does have a \'name tag\'' do
      it 'parses hostname from name tag' do
        expect(formatted).to include('hello-world-001')
      end

      it 'returns a tab separated string with hostname and IP address' do
        expect(formatted).to eq("hello-world-001\t10.0.0.1")
      end
    end

    context 'when instance does not have a \'name tag\'' do
      let :name_tag do
        'name'
      end

      it 'uses private DNS name instead' do
        expect(formatted).to eq("private-dns-name\t10.0.0.1")
      end
    end
  end
end
