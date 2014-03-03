require 'execjs'

module Rack
  class Browserify
    def initialize(app, options)
      @app = app;
      @options = {}.update({
        :transforms => [],
        :basedir => ""
      }).update(options)
    end

    def call(env)

    end


  end
end