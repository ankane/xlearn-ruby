# dependencies
require "fiddle"
require "fiddle/import"

# stdlib
require "csv"
require "fileutils"
require "tempfile"

# modules
require "xlearn/utils"
require "xlearn/dmatrix"
require "xlearn/model"
require "xlearn/ffm"
require "xlearn/fm"
require "xlearn/linear"
require "xlearn/version"

module XLearn
  class Error < StandardError; end

  class << self
    attr_accessor :ffi_lib
  end
  self.ffi_lib = ["libxlearn_api.so", "libxlearn_api.dylib", "xlearn_api.dll"]

  # friendlier error message
  autoload :FFI, "xlearn/ffi"
end
