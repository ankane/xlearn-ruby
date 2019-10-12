module XLearn
  class DMatrix
    include Utils

    def initialize(data, label: nil)
      @handle = ::FFI::MemoryPointer.new(:pointer)

      nrow = data.count
      ncol = data.first.count

      c_data = ::FFI::MemoryPointer.new(:float, nrow * ncol)
      c_data.put_array_of_float(0, data.flatten)

      if label
        c_label = ::FFI::MemoryPointer.new(:float, nrow)
        c_label.put_array_of_float(0, label)
      end

      # TODO support this
      field_map = nil

      check_call FFI.XlearnCreateDataFromMat(c_data, nrow, ncol, c_label, field_map, @handle)
      ObjectSpace.define_finalizer(self, self.class.finalize(@handle))
    end

    def to_ptr
      @handle
    end

    def self.finalize(pointer)
      # must use proc instead of stabby lambda
      proc { FFI.XlearnDataFree(pointer) }
    end
  end
end
