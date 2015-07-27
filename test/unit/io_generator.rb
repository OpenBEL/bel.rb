# Subprocess script used by test/unit/test_nonblocking_io_wrapper.rb

ITERATIONS = 10
CHUNK_SIZE = ARGV.first.to_i

(threads ||= []) << Thread.new do
  ITERATIONS.times do
    $stdout.write Random.new.bytes(CHUNK_SIZE)
    $stdout.flush
    sleep(0.05)
  end
end

threads.each(&:join)
