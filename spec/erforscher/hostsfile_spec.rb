# encoding: utf-8

require 'spec_helper'

module Erforscher
  describe Hostsfile do
    let :hostsfile do
      described_class.new(current_file, new_file, fileutils: fileutils)
    end

    let :new_file do
      StringIO.new
    end

    let :fileutils do
      double(:fileutils).as_null_object
    end

    let :entries do
      3.times.map { |i| %(host-00#{i}\t10.0.0.#{i}) }
    end

    def next_line
      (line = new_file.gets) && line.strip
    end

    describe '#write' do
      before do
        hostsfile.write(entries)
        new_file.rewind
      end

      context 'a pristine file' do
        let :current_file do
          StringIO.new.tap do |io|
            io.puts %(# Comment at the start of file)
            io.puts %(127.0.0.1\tno-place-like.home)
            io.rewind
          end
        end

        it 'copies everything until header to new file' do
          expect(next_line).to eq(%(# Comment at the start of file))
          expect(next_line).to eq(%(127.0.0.1\tno-place-like.home))
        end

        it 'writes entries to new file' do
          3.times { next_line }
          expect(next_line).to eq("host-000\t10.0.0.0")
          expect(next_line).to eq("host-001\t10.0.0.1")
          expect(next_line).to eq("host-002\t10.0.0.2")
        end

        it 'writes a footer' do
          6.times { next_line }
          expect(next_line).to eq('# ERFORSCHER END')
        end

        it 'copies everything after footer to new file' do
          7.times { next_line }
          expect(next_line).to be_nil
        end
      end

      context 'a file that has been written before' do
        let :current_file do
          StringIO.new.tap do |io|
            io.puts %(# Comment at the start of file)
            io.puts %(127.0.0.1\tno-place-like.home)
            io.puts %(# ERFORSCHER START)
            io.puts %(host-000\t10.0.0.0)
            io.puts %(# ERFORSCHER END)
            io.puts %(# Something after footer)
            io.rewind
          end
        end

        it 'copies everything until header to new file' do
          expect(next_line).to eq(%(# Comment at the start of file))
          expect(next_line).to eq(%(127.0.0.1\tno-place-like.home))
        end

        it 'writes entries to new file' do
          3.times { next_line }
          expect(next_line).to eq("host-000\t10.0.0.0")
          expect(next_line).to eq("host-001\t10.0.0.1")
          expect(next_line).to eq("host-002\t10.0.0.2")
        end

        it 'writes footer once' do
          6.times { next_line }
          expect(next_line).to eq('# ERFORSCHER END')
        end

        it 'does not keep old entries around' do
          7.times { next_line }
          expect(next_line).to eq('# Something after footer')
          expect(next_line).to be_nil
        end
      end
    end

    describe '#switchero' do
      let :new_file do
        Tempfile.new('new_file')
      end

      let :current_file do
        Tempfile.new('current_file')
      end

      let :absolute_current_path do
        File.absolute_path(current_file)
      end

      let :absolute_new_path do
        File.absolute_path(new_file)
      end

      before do
        hostsfile.switchero
      end

      it 'closes the new file' do
        new_file.should be_closed
      end

      it 'backups the previous file' do
        fileutils.should have_received(:mv).with(absolute_current_path, %(#{absolute_current_path}.prev))
      end

      it 'renames the new file' do
        fileutils.should have_received(:mv).with(absolute_new_path, absolute_current_path)
      end
    end
  end
end
