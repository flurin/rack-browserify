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

  def test_param_simple_boolean
    assert_equal ["--debug"], @browserify.build_command(:debug => true)[1..-1]
    assert_equal [], @browserify.build_command(:debug => false)[1..-1]    
  end

  def test_param_simple_string
    assert_equal ["--ignore", "t"], @browserify.build_command(:ignore => "t")[1..-1]
    assert_equal ["--ignore", "true"], @browserify.build_command(:ignore => true)[1..-1]
  end

  def test_param_multiple_string
    assert_equal ["--transform", "1", "--transform", "2"], @browserify.build_command(:transform => ["1", "2"])[1..-1]
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