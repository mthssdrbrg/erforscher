# encoding: utf-8

require 'spec_helper'

module Erforscher
  describe Explorer do
    let :explorer do
      described_class.new(instances)
    end

    let :instances do
      Instances.new(FakeEc2.new(Resource.instances))
    end

    let :filtered do
      explorer.discover(tags)
    end

    describe '#discover' do
      context 'with a single tag' do
        let :tags do
          [{'Environment' => 'test'}]
        end

        it 'filters instances by given tag' do
          expect(filtered).to have(2).items
        end
      end

      context 'with multiple tags' do
        let :tags do
          [{'Environment' => 'test', 'Group' => 'Some group'}]
        end

        it 'filters instances by given tags' do
          expect(filtered).to have(1).item
        end
      end

      context 'with multiple tag combinations' do
        let :tags do
          [{'Environment' => 'test', 'Group' => 'Some group'}, {'Environment' => 'test2'}]
        end

        it 'concats filtered instances' do
          expect(filtered).to have(2).items
        end
      end

      context 'when given an empty list of tag combinations' do
        let :tags do
          []
        end

        it 'returns all instances' do
          expect(filtered).to have(5).items
        end
      end
    end
  end
end
