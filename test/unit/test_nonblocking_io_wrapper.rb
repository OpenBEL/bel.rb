require 'minitest'
require 'minitest/autorun'
require 'tempfile'

# prepend lib/ dir to LOAD_PATH so we can 'require' from the tree
$:.unshift File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'lib')
require 'bel/nonblocking_io_wrapper'

# Test for {NonblockingIOWrapper}.
#
# Purpose: Determine that we do not block based on read buffer length,
# but rather on IO availability.
#
# Mechanism:
#
# - Spawn a subprocess and iteratively write out a small chunk of bytes
#   interleaved with sleeps.
# - {#test_read_less_than_buffer_size} will then attempt to read a larger
#   chunk into our buffer.
# - The assertion holds when the buffer contains less than the large buffer
#   length. This demonstrates the effect of non-blocking IO.
# - The assertion is refuted when the buffer contains it's large buffer
#   length. This indicates that a blocking read occurred.
class TestNonblockingIOWrapper < Minitest::Test

  SUBPROCESS_WRITE_LENGTH_BYTES  = 32
  THIS_PROCESS_READ_LENGTH_BYTES = 128
  SCRIPT_DIR         = File.join(File.expand_path('..', __FILE__))

  def setup
    @read_io, @write_io = IO.pipe
    @pid = spawn(
      "ruby io_generator.rb #{SUBPROCESS_WRITE_LENGTH_BYTES}",
      :chdir => SCRIPT_DIR,
      :out => @write_io
    )
    @write_io.close
    @io_wrapper = NonblockingIOWrapper.new(
      @read_io,
      THIS_PROCESS_READ_LENGTH_BYTES
    )
  end

  # Asserts that we _always_ read less than our buffer size when IO is
  # available.
  def test_read_less_than_buffer_size
    @io_wrapper.each { |buffer|
      assert (buffer.length < THIS_PROCESS_READ_LENGTH_BYTES), "Blocking read"
    }
  end

  def teardown
    Process.wait @pid
    @read_io.close
  end
end
