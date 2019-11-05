module XLearn
  class DMatrix
    include Utils

    def initialize(data, label: nil)
      @handle = Fiddle::Pointer.malloc(Fiddle::SIZEOF_VOIDP)

      if matrix?(data)
        nrow = data.row_count
        ncol = data.column_count
        flat_data = data.to_a.flatten
      elsif daru?(data)
        nrow, ncol = data.shape
        flat_data = data.map_rows(&:to_a).flatten
      elsif narray?(data)
        nrow, ncol = data.shape
        # TODO convert to SFloat and pass pointer
        # for better performance
        flat_data = data.flatten.to_a
      else
        nrow = data.count
        ncol = data.first.count
        flat_data = data.flatten
      end

      c_data = Fiddle::Pointer[flat_data.pack("f*")]

      if label
        label = label.to_a
        c_label = Fiddle::Pointer[label.pack("f*")]
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

    private

    def matrix?(data)
      defined?(Matrix) && data.is_a?(Matrix)
    end

    def daru?(data)
      defined?(Daru::DataFrame) && data.is_a?(Daru::DataFrame)
    end

    def narray?(data)
      defined?(Numo::NArray) && data.is_a?(Numo::NArray)
    end
  end
end
