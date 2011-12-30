require 'parameters'

class OptionParameters

  include Parameters

  parameter :path, :description => 'Path to the file'

  parameter :with_foo, :description => 'Multiword param name'

  parameter :type, :type        => Symbol,
                   :description => 'Type to use'

  parameter :count, :type        => Integer,
                    :default     => 100,
                    :description => 'Max count'

  parameter :names, :type        => Array[String],
                    :description => 'Names to search for'

  parameter :ids, :type        => Set[Integer],
                  :description => 'IDs to search for'

  parameter :verbose, :type        => true,
                      :description => 'Enable version'

  parameter :mapping, :type        => Hash[Symbol => Integer],
                      :description => 'Mapping of names to integers'

end
