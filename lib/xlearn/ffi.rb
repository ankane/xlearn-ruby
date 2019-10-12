module XLearn
  module FFI
    extend ::FFI::Library

    begin
      ffi_lib XLearn.ffi_lib
    rescue LoadError => e
      raise e if ENV["XLEARN_DEBUG"]
      raise LoadError, "Could not find xLearn"
    end

    # https://github.com/aksnzhy/xlearn/blob/master/src/c_api/c_api.h
    # keep same order

    attach_function :XLearnHello, %i[], :int
    attach_function :XLearnCreate, %i[string pointer], :int
    attach_function :XlearnCreateDataFromMat, %i[pointer uint32 uint32 pointer pointer pointer], :int
    attach_function :XlearnDataFree, %i[pointer], :int
    attach_function :XLearnHandleFree, %i[pointer], :int
    attach_function :XLearnShow, %i[pointer], :int
    attach_function :XLearnSetTrain, %i[pointer string], :int
    attach_function :XLearnSetTest, %i[pointer string], :int
    attach_function :XLearnSetPreModel, %i[pointer string], :int
    attach_function :XLearnSetValidate, %i[pointer string], :int
    attach_function :XLearnSetTXTModel, %i[pointer string], :int
    attach_function :XLearnFit, %i[pointer string], :int
    attach_function :XLearnCV, %i[pointer], :int
    attach_function :XLearnPredictForMat, %i[pointer string pointer pointer], :int
    attach_function :XLearnPredictForFile, %i[pointer string string], :int
    attach_function :XLearnSetDMatrix, %i[pointer string pointer], :int
    attach_function :XLearnSetStr, %i[pointer string string], :int
    attach_function :XLearnSetInt, %i[pointer string int], :int
    attach_function :XLearnSetFloat, %i[pointer string float], :int
    attach_function :XLearnSetBool, %i[pointer string bool], :int

    # errors
    attach_function :XLearnGetLastError, %i[], :string
  end
end
