= Parameters

* http://parameters.rubyforge.org/
* http://github.com/postmodern/parameters
* Postmodern (postmodern.mod3 at gmail.com)

== DESCRIPTION:

Parameters allows you to add annotated variables to your classes which may
have configurable default values.

== FEATURES:

* Give parameters default values.
  * Default values maybe either objects or lambdas used to generate the
    default value.
* Change default values of parameters.
* Give descriptions to parameters.

== EXAMPLES:

  class Octagon
  
    include Parameters
  
    parameter :x, :default => 0
  
    parameter :y, :default => 0.5
  
    parameter :radius, :description => 'The radius of the Octagon'

    parameter :opacity,
              :default => lambda { rand },
              :description => 'The opacity of the Octagon'
  
  end
  
  oct = Octagon.new
  oct.x # => 0
  oct.y # => 0.5
  oct.opacity # => 0.25
  
  oct = Octagon.new(:radius => 10)
  oct.radius # => 10
  oct.opacity # => 0.7
  
  Octagon.radius = 33
  Octagon.opacity = 0.3
  
  oct = Octagon.new
  oct.radius # => 33
  oct.opacity # => 0.3

== INSTALL:

  $ sudo gem install parameters

== LICENSE:

The MIT License

Copyright (c) 2008-2009 Hal Brodigan

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
