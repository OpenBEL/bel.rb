# Provides a platform-independent, non-blocking wrapper for reading an
# {http://ruby-doc.org/core-2.2.2/IO.html IO}-like object. This wrapper
# object must be enumerated using the {#each} method.
class NonblockingIOWrapper

  # Initialize this wrapper around the +io+ object and read at most
  # +read_length+ bytes in a non-blocking manner.
  #
  # @param [IO]     io          an IO-like object
  # @param [Fixnum] read_length the buffer length to read
  def initialize(io, read_length = (128 * 1024))
    @io          = io
    @read_length = read_length
    @read_method = nonblocking_read(@io)
  end

  # Yields each buffer read from the wrapped IO-like object to the provided
  # block (e.g. +{ |block| ... }+). The read length is set on {#initialize}.
  #
  # @yield the buffers read from the IO-like object
  # @yieldparam [String] buffer the read buffer as uninterpreted bytes
  def each
    begin
      while buffer = @read_method.call(@read_length)
        yield buffer
      end
    rescue IO::WaitReadable
      IO.select([@io])
      retry
    rescue EOFError
      # end of stream; parsing complete
    end
  end

  private

  # Returns the method, appropriate for your platform, to read IO in a
  # non-blocking manner.
  #
  # @example Call directly.
  #   nonblocking_read(StringIO.new('hello')).call(4)
  #
  # @param  [IO] io an IO-like object
  # @return [Method] a non-blocking read method
  def nonblocking_read(io)
    if Gem.win_platform?
      io.method(:sysread)
    else
      io.method(:read_nonblock)
    end
  end
end
