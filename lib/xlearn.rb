# dependencies
require "ffi"

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
  lib_name = FFI.map_library_name("xlearn_api")
  vendor_lib = File.expand_path("../vendor/#{lib_name}", __dir__)
  self.ffi_lib = [vendor_lib]

  # friendlier error message
  autoload :FFI, "xlearn/ffi"
end
