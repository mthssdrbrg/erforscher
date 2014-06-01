# encoding: utf-8

module Erforscher
  class Hostsfile
    def initialize(current_file, new_file, options={})
      @current_file = current_file
      @new_file = new_file
      @fileutils = options[:fileutils] || FileUtils
      @previously_written = false
    end

    def write(entries)
      copy_until_header
      write_header
      write_body(entries)
      write_footer
      discard_old_entries
      copy_after_footer
    end

    def switch
      @new_file.close
      @current_file.close
      @fileutils.mv(current_path, current_prev_path)
      @fileutils.mv(new_path, current_path)
      @fileutils.chmod(0644, current_path)
    end

    private

    def new_path
      @new_path ||= @new_file.path
    end

    def current_path
      @current_path ||= absolute_path(@current_file)
    end

    def current_prev_path
      @current_prev_path ||= %(#{absolute_path(@current_file)}.prev)
    end

    def absolute_path(f)
      File.absolute_path(f)
    end

    def header
      '# ERFORSCHER START'
    end

    def footer
      '# ERFORSCHER END'
    end

    def copy_until_header
      while (line = @current_file.gets)
        if line.match(header)
          @previously_written = true
          break
        else
          @new_file.write(line)
        end
      end
    end

    def write_header
      @new_file.puts(header)
    end

    def write_body(entries)
      entries.each do |entry|
        @new_file.puts(entry)
      end
    end

    def write_footer
      @new_file.puts(footer)
    end

    def discard_old_entries
      if @previously_written
        while (line = @current_file.gets)
          if line.match(footer)
            break
          end
        end
      end
    end

    def copy_after_footer
      while (line = @current_file.gets)
        @new_file.write(line)
      end
    end
  end
end
