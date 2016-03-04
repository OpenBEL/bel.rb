# This is a helper script loaded when "yard doctest" runs. This allows
# @example code blocks to be tested.
#
# We use this file to augment the objects available to @example tags.

# Manually place 'lib/' on the require path.
# The yard-doctest plugin does not do this for you.
$:.unshift File.join(File.dirname(File.expand_path(__FILE__)), '..', 'lib')

require 'bel'
include BEL::Quoting
