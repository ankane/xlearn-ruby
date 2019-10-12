module XLearn
  module Utils
    private

    def check_call(ret)
      raise Error, FFI.XLearnGetLastError if ret != 0
    end
  end
end
