# Parameters

* [Source](https://github.com/postmodern/parameters)
* [Issues](https://github.com/postmodern/parameters/issues)
* [Documentation](http://rubydoc.info/gems/parameters/frames)
* [Email](mailto:postmodern.mod3 at gmail.com)

## Description

Parameters allows you to add annotated variables to your classes which may
have configurable default values.

## Features

* Give parameters default values.
  * Default values maybe either objects or lambdas used to generate the
    default value.
* Change default values of parameters.
* Enforce types on the values of parameters.
* Give descriptions to parameters.
* Set parameters en-mass.

## Examples

    require 'parameters'

    class Octagon
  
      include Parameters
  
      #
      # A parameter with a default value
      #
      parameter :x, :default => 0
  
      #
      # Another parameter with a default value
      #
      parameter :y, :default => 0.5
  
      #
      # A parameter with an enforced type and description.
      #
      # Availble types are: Array[Class], Array, Set[Class], Set,
      # URI, Regexp, DateTime, Date, Symbol, String, Integer, Float
      # and true (for boolean types).
      #
      parameter :radius, :type        => Float,
                         :description => 'The radius of the Octagon'

      #
      # A parameter with a lambda for a default value
      #
      parameter :opacity, :default     => lambda { rand },
                          :description => 'The opacity of the Octagon'
  
    end
  
    # Create an object with default values for all parameters
    oct = Octagon.new
    oct.x       # => 0
    oct.y       # => 0.5
    oct.opacity # => 0.25
  
    # Create an object with the given parameter values.
    oct = Octagon.new(:radius => 10)
    oct.radius  # => 10
    oct.opacity # => 0.7
  
    # Set parameter values of a class
    Octagon.radius = 33
    Octagon.opacity = 0.3
  
    # Create an object with parameter defaulte values inherited from the
    # class parameters
    oct = Octagon.new
    oct.radius  # => 33
    oct.opacity # => 0.3

    # Coerce data from the command-line into the given parameter type
    oct.radius = ARGV[2]
    oct.radius # => 89.455

## Install

    $ gem install parameters

## License

See {file:LICENSE.txt} for license information.
