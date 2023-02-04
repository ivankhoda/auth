require "rubocop"

require "standard/rubocop/ext"

require "standard/version"
require "standard/cli"
require "standard/railtie" if defined?(Rails)

require "standard/formatter"
require "standard/cop/semantic_blocks"

module Standard
end
