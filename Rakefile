# Rakefile for HFST

# add current directory and lib directory to load path
$LOAD_PATH << __dir__
$LOAD_PATH << File.join(__dir__, "lib")

require 'lib/hfst'

# Constants
PROJ_ROOT = File.expand_path(__dir__)
DATA_DIR  = File.join(PROJ_ROOT, "public", "data")

Dir["#{PROJ_ROOT}/lib/tasks/**/*.rake"].each do |path|
  load path
end
