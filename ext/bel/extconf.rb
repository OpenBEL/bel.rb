require 'mkmf'

RbConfig::MAKEFILE_CONFIG['CC'] = ENV['CC'] if ENV['CC']

$CFLAGS << " #{ENV["CFLAGS"]}"
$CFLAGS << " -g"
$CFLAGS << " -O3" unless $CFLAGS[/-O\d/]
$CFLAGS << " -Wall -Wno-comment"

if !(MAKE = find_executable('gmake') || find_executable('make'))
  abort "ERROR: GNU make is required to build Rugged."
end

CWD = File.expand_path(File.dirname(__FILE__))
LIBBEL_DIR = File.join(CWD, '..', '..', 'vendor', 'libbel')

Dir.chdir(LIBBEL_DIR) do
  system("./autogen.sh")
  system("./configure")
  system("#{MAKE} clean all")
end

# By putting the path to the vendored libbel library at the front of
# $DEFLIBPATH, we can ensure that our bundled version is always used.
$DEFLIBPATH.unshift("#{LIBBEL_DIR}/src/.libs")
dir_config('bel', "#{LIBBEL_DIR}/src/.libs")

unless have_library 'bel'
  abort "ERROR: Failed to build libbel"
end

create_makefile("bel/bel")
