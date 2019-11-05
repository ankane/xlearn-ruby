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
  self.ffi_lib =
    case RbConfig::CONFIG["host_os"]
    when /mingw|mswin/i
      ["xlearn_api.dll"]
    when /darwin/i
      ["libxlearn_api.dylib"]
    else
      ["libxlearn_api.so"]
    end

  # friendlier error message
  autoload :FFI, "xlearn/ffi"
end
