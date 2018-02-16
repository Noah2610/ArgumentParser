# ArgumentParser
by Noah Rosenzweig  
  
A simple CLI arguments / options parser written in __Ruby__.

---

## Building Ruby Gem
If you like this script and think you will use it a bit,  
you can create and install a gem from it.  
Run these commands in the root of the project:  
```sh
$ gem build ./argument_parser.gemspec
$ gem install argument_parser
```

## Usage
Either build a gem, as seen above, and `require 'argument_parser'`  
in your script, or just copy the file `./lib/argument_parser.rb` and  
require it like this `require_relative './PATH/TO/argument_parser'`.  
  
This gem provides the class `ArgumentParser`.  
Currently it only contains a single method: `ArgumentParser.get_arguments`.  
You pass it a hash which contains your defined, valid arguments.  
An example usage script is included in this repo `./demo.rb`  
in which there is a constant called `DEMO_VALID_ARGUMENTS`, that will show you  
the required syntax of the hash that is passed to the method.  
  
Basically you can define  
__single-dash__ (-) options, __double-dash__ (--) options,  
and __keywords__ (arguments without dashes).  
Keywords are a bit experimental, but generally they are a list  
of _keyword chains_ that are used from the command-line in order.  
  
### Example
```ruby
## Here the arguments you want the user to be able to use are defined.
VALID_ARGUMENTS = {
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
    set:           [['set','define'],         ['var','constant'],       :INPUT,             :INPUTS]
#   ^^^             ^^^^^^^^^^^^^^^^          ^^^^^^^^^^^^^^^^^^        ^^^^^^              ^^^^^^^
# Main identifier   list of possible first    list of possible second   special symbol      special symbol,
# of this           keywords, user can only   keywords                  that takes any      similar to :INPUT
# keyword-chain     use one of these at the                             user input and      but takes an unlimited
#                   first position                                      places it at this   amount of user input;
#                   (ignoring options)                                  position            this should be the last
#                                                                       (one argument)      keyword in the chain
#                                                                                           (multiple arguments)
  }
}

## Processed arguments returned in a formated hash
user_arguments = ArgumentParser.get_arguments VALID_ARGUMENTS

puts "Given Arguments:"
ap user_arguments        # Print the user's arguments in a formated structure, using the awesome_print gem
```
```sh
$ ./demo.rb -hv set --status FOO constant BAR --this -is ignored
Given Arguments:
{
   :options => {
         :help => true,
      :version => true,
       :status => "FOO"
  },
  :keywords => {
      :set => [
          [0] "set",
          [1] "constant",
          [2] "BAR"
      ]
  }
}
```
The above script won't just work if you copy/paste it, use the included  
`./demo.rb` script, which uses the same configuration as above.  
  
You can see that those three extra options / keywords (`--this -is ignored`)  
at the end are ignored because they weren't defined in `VALID_ARGUMENTS`.  
This will probably change in the future, so the user gets feedback  
about their arguments being invalid.
  
When using the `./demo.rb` script it is recommended to have the gem  
[`awesome_print`](https://github.com/awesome-print/awesome_print) installed; the gem _pretty prints_ ruby objects.  
It's _pretty awesome_.  
Install with `$ gem install awesome_print`.  

