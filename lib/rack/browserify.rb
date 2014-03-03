require "browserify/command"

module Rack
  class Browserify
    def initialize(app, options={})
      @app = app
      @browserify = ::Browserify::Command.new(options)
      @options = {}.update({
        :basedir => nil,
        :skip => []
      }).update(options)
    end

    def call(env)
      status, headers, body = @app.call(env)
      
      if status == 200 && headers["Content-Type"].to_s.include?("application/javascript") && !@options[:skip].detect{|r| r.match(env["PATH_INFO"]) }
        body_str = []
        body.each{|f| body_str << f }
        body_str = body_str.join
        
        # This is a dirty little hack to always enforce UTF8
        body_str.force_encoding("UTF-8")
      
        if @options[:basedir]
          body_new = ""
          Dir.chdir(@options[:basedir]) do
            body_new = @browserify.call(body_str, :type => :string)
          end
        else
          body_new = @browserify.call(body_str, :type => :string)
        end

        Rack::Response.new(body_new, status, headers).finish
      else
        [status, headers, body]
      end
    end
  end
end