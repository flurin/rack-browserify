require 'shellwords'

module Browserify
  class Command

    BROWSERIFY_PARAMS = [
      [:entry, :string],
      [:ignore, :string],
      [:exclude, :string],
      [:transform, :string],
      [:command, :string],
      [:standalone, :boolean],
      [:debug, :boolean]
    ]

    def initialize(options = {})
      @options = {
        :browserify_bin => nil,
        :type => :string
      }

      @options = @options.update(options)
    end

    def call(file, options)
      

      cmd = build_command(options)

      if options[:type] == :string
        out = ""
        IO.popen(Shellwords.join(cmd), "w+") do |p|
          p.write(file)
          p.close_write

          out = p.read
        end
        out
      else
        cmd << file
        `#{Shellwords.join(cmd)}`
      end
    end

    def build_command(options)
      options = {}.update(@options).update(options)
      cmd = [self.browserify_bin]

      BROWSERIFY_PARAMS.each do |key, type|
        next unless options.has_key?(key)

        if options[key].kind_of?(Array)
          options[key].each do |opt|
            cmd += build_param(key, opt, type)
          end
        elsif options[key]
          cmd += build_param(key, options[key], type)
        end
      end

      cmd
    end

    def build_param(key, value, type = :string)
      cmd = ["--#{key}"]
      if type != :boolean
        cmd << value.to_s
      end
      cmd
    end

    def browserify_bin
      return @_bin if @_bin

      if @options[:browserify_bin]
        if self.try_bin(@options[:browserify_bin])
          @_bin = @options[:browserify_bin]
        end
      else

        if self.try_bin("npm")
          # npm?          
          npm_bindir = `npm bin`.strip()
          bin = npm_bindir + "/browserify"
          if File.exist?(bin) && try_bin(bin + " -v")
            @_bin = bin
          end
        else
          # global?
          if self.try_bin("browserify -v")
            @_bin = "browserify"
          end
        end
      end

      if !@_bin
        raise RuntimeError, "No suitable 'browserify' bin found"
      else
        @_bin
      end
    end

    def try_bin(bin)
      begin
        `#{bin}`
      rescue Errno::ENOENT
        return false
      end
      true
    end
  end
end