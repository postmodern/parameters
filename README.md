# Parameters

* http://parameters.rubyforge.org/
* http://github.com/postmodern/parameters/
* Postmodern (postmodern.mod3 at gmail.com)

## Description

Parameters allows you to add annotated variables to your classes which may
have configurable default values.

## Features

* Give parameters default values.
  * Default values maybe either objects or lambdas used to generate the
    default value.
* Change default values of parameters.
* Give descriptions to parameters.
* Set parameters en-mass.
* Parse strings of the form `name=value` into a Hash of parameters.

## Examples

    class Octagon
  
      include Parameters
  
      parameter :x, :default => 0
  
      parameter :y, :default => 0.5
  
      parameter :radius, :description => 'The radius of the Octagon'

      parameter :opacity,
                :default => lambda { rand },
                :description => 'The opacity of the Octagon'
  
    end
  
    # Create an object with default values for all parameters
    oct = Octagon.new
    oct.x # => 0
    oct.y # => 0.5
    oct.opacity # => 0.25
  
    # Create an object with the given parameter values.
    oct = Octagon.new(:radius => 10)
    oct.radius # => 10
    oct.opacity # => 0.7
  
    # Set parameter values of a class
    Octagon.radius = 33
    Octagon.opacity = 0.3
  
    # Create an object with parameter defaulte values inherited from the
    # class parameters
    oct = Octagon.new
    oct.radius # => 33
    oct.opacity # => 0.3

    # Parse user given name=value parameter strings
    oct.params = Parameters::Parser.parse(ARGV)

## Install

    $ sudo gem install parameters

## License

See {file:LICENSE.txt} for license information.

