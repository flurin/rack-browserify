require "test/unit"
require "shellwords"

require "browserify/command"

class TestBrowserifyCommand < Test::Unit::TestCase

  def setup
    @pwd = Dir.pwd
    Dir.chdir(File.dirname(__FILE__) + "/project")    
    @browserify = Browserify::Command.new
  end

  def teardown
    Dir.chdir(@pwd)
  end


  def test_bin_available
    assert @browserify.browserify_bin
  end

  def test_call_with_file
    file = "test_console.js"
    output = @browserify.call(file, :type => :file)
    assert_equal node(file), node_str(output)
  end

  def test_call_with_string
    str = "console.log('yeah');";
    output = @browserify.call(str, :type => :string);
    assert_equal node_str(output), node_str(str)
  end

  # Helper to run JS through node;
  def node(file)
    cmd = ["node", file]
    `#{Shellwords.join(cmd)}`
  end

  def node_str(str)
    cmd = ["node"]
    out = ""
    IO.popen(Shellwords.join(cmd), "w+") do |p|
      p.write(str)
      p.close_write
      out = p.read
    end
  end

end