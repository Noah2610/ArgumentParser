#!/bin/env ruby

require_relative './lib/argument_parser'

## require awesome_print gem for formated hash output, if installed
AP_INSTALLED = `gem list -i awesome_print`.strip == 'true'
require 'awesome_print'  if (AP_INSTALLED)

## Here the arguments you want the user to be able to use are defined.
DEMO_VALID_ARGUMENTS = {
  ## Single option example (-a, -b):
  single: {
    help:        [['h','H'],               false],  # -h
#   ^^^^            ^   ^                  ^^^^^
# Identifier,  command-line option(s), accepts value?
    version:     [['v','V'],               false]   # -v
  },

  ## Double option example (--foo, --bar):
  double: {
    help:        [['help'],                false],  # --help
    version:     [['version'],             false],  # --version
    status:      [['status'],              true]    # --status USER-INPUT
  },

  ## Keywords are positional, ignoring option positions
  keywords: {
    set:           [['set','define'],         ['var','constant'],       :INPUT],
#   ^^^             ^^^^^^^^^^^^^^^^          ^^^^^^^^^^^^^^^^^^        ^^^^^^
# Main identifier   list of possible first    list of possible second   special symbol
# of this           keywords, user can only   keywords                  that takes any
# keyword-chain     use one of these at the                             user input and
#                   first position                                      places it at this
#                   (ignoring options)                                  position
  }
}

## Get and process CLI arguments
args = ArgumentParser.get_arguments DEMO_VALID_ARGUMENTS
## Output the user's arguments in a formated and processed structure
puts "Given Arguments:"
if (AP_INSTALLED)
  ap args
else
  puts args.to_s
end

