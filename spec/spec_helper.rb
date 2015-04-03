$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'coveralls'
Coveralls.wear!

require 'smarty_streets'
require 'rspec'

RSpec.configure do |c|
  c.mock_with(:rspec)
end
