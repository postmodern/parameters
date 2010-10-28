### 0.2.3 / 2010-10-27

* Have parameter reader/writer class-methods search down the ancestory
  tree for a given class parameter.

### 0.2.2 / 2010-08-06

* Require Bundler ~> 1.0.0.
* Updated {Parameters::InstanceParam#inspect} and
  {Parameters::ClassParam#inspect} to also include the class-name.
* Use `included_modules.include?` when testing whether {Parameters}
  was included.
* Fix failing specs for Rubinius.

### 0.2.1 / 2010-05-05

* Added {Parameters::ClassMethods#included}, so that
  {Parameters::ClassMethods} can be re-extended by mixin modules which
  include {Parameters}.
* Added {Parameters::Param#coerce_hash}.
* Allow a `Proc` to be given as the coercion type for
  {Parameters::Param#coerce_type}.
* Allow custom classes to be used for coercion types.
* Ruby 1.8.6 bug fixes for {Parameters::Param#coerce_type}.

### 0.2.0 / 2010-02-18

* Migrated to [Jeweler](http://github.com/technicalpickles/jeweler)
  for packaging rubygems.
* Added type enforcement / coercion to parameters:
  * Added the `:type` option to the `parameter` method.
  * Available types:
    * Array[Class]
    * Array
    * Set[Class]
    * Set
    * URI
    * Regexp
    * DateTime
    * Date
    * Symbol
    * String
    * Integer
    * Float
    * true (for boolean types).
  * Removed `Parameters::Parser` in favor of type enforcement / coercion.
* Switched to MarkDown formatted YARD documentation.
* Moved the YARD parameter handlers into
  [yard-parameters](http://github.com/postmodern/yard-parameters) library.

### 0.1.9 / 2009-01-30

* Require RSpec >= 1.3.0.
* Require YARD >= 0.5.3.
* Added {Parameters::ClassMethods}.

### 0.1.8 / 2009-09-21

* Require Hoe >= 2.3.3.
* Require YARD >= 0.2.3.5.
* Require RSpec >= 1.2.8.
* Use 'hoe/signing' for signed RubyGems.
* Moved to YARD based documentation.
* Added YARD handlers for documenting parameter method calls.
* All specs pass on JRuby 1.3.1.

### 0.1.7 / 2009-07-19

* Renamed Parameters#initialize_parameters to
  {Parameters#initialize_params}.
* Adjust spacing in the output of {Parameters::ClassParam#to_s}
  and {Parameters::InstanceParam#to_s}.
* Specifically check if the instance variable is nil
  before initializing it to the default value of the parameter.
* Handle default value callbacks in {Parameters#parameter}.
* Check the arity of all default value callbacks, before
  passing self to them.
* {Parameters#require_params} now specifically tests if
  the instance variable of the parameter is nil.
* Added more specs.

### 0.1.6 / 2009-05-11

* Fixed a bug in {Parameters::ClassMethods#params=} and {Parameters#params=},
  where they were not handling {Parameters::ClassParam} or
  {Parameters::InstanceParam} objects properly.
* Added more specs.

### 0.1.5 / 2009-05-06

* Added Parameters::Parser for parsing parameter values passed in from
  the command-line or the web.
* Changed {Parameters::MissingParam} and {Parameters::ParamNotFound} to
  inherit from StandardError.
* All specs pass on Ruby 1.9.1-p0.

### 0.1.4 / 2009-01-17

* All specs now pass with RSpec 1.1.12.
* All specs pass on Ruby 1.9.1-rc1.

### 0.1.3 / 2009-01-14

* Allow the use of lambdas to generate the default values of parameters.
* Fixed typos in the README.txt.

### 0.1.2 / 2009-01-06

* When printing parameter values, print the inspected version of the value.

### 0.1.1 / 2008-12-27

* Added the require_params helper method.
* Added print_params methods for displaying parameters of a class or an
  object.

### 0.1.0 / 2008-12-03

* Initial release.
* Added {Parameters::ClassMethods#params=} and {Parameters#params=} methods.
* Allow Parameters#initialize to accept a Hash of parameter values.
* Added more specs.

