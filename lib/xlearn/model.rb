module XLearn
  class Model
    include Utils

    def initialize(**options)
      @handle = ::FFI::MemoryPointer.new(:pointer)
      check_call FFI.XLearnCreate(@model_type, @handle)
      ObjectSpace.define_finalizer(self, self.class.finalize(@handle))

      options = {
        task: "binary",
        quiet: true
      }.merge(options)

      if options[:task] == "binary" && !options.key?(:sigmoid)
        options[:sigmoid] = true
      end

      set_params(options)
    end

    def fit(x, y = nil, eval_set: nil)
      set_train_set(x, y)

      if eval_set
        if eval_set.is_a?(String)
          check_call FFI.XLearnSetValidate(@handle, eval_set)
        else
          valid_set = DMatrix.new(x, label: y)
          check_call FFI.XLearnSetDMatrix(@handle, "validate", valid_set)
        end
      end

      @txt_file = create_tempfile
      check_call FFI.XLearnSetTXTModel(@handle, @txt_file.path)

      @model_file = create_tempfile
      check_call FFI.XLearnFit(@handle, @model_file.path)
    end

    def predict(x, out_path: nil)
      if x.is_a?(String)
        check_call FFI.XLearnSetTest(@handle, x)
        check_call FFI.XLearnSetBool(@handle, "from_file", true)
      else
        test_set = DMatrix.new(x)
        check_call FFI.XLearnSetDMatrix(@handle, "test", test_set)
        check_call FFI.XLearnSetBool(@handle, "from_file", false)
      end

      if out_path
        check_call FFI.XLearnPredictForFile(@handle, @model_file.path, out_path)
      else
        length = ::FFI::MemoryPointer.new(:uint64)
        out_arr = ::FFI::MemoryPointer.new(:pointer)
        check_call FFI.XLearnPredictForMat(@handle, @model_file.path, length, out_arr)
        out_arr.read_pointer.read_array_of_float(length.read_uint64)
      end
    end

    def cv(x, y = nil, folds: nil)
      set_params(fold: folds) if folds
      set_train_set(x, y)
      check_call FFI.XLearnCV(@handle)
    end

    def save_model(path)
      raise Error, "Not trained" unless @model_file
      FileUtils.cp(@model_file.path, path)
    end

    def save_txt(path)
      raise Error, "Not trained" unless @txt_file
      FileUtils.cp(@txt_file.path, path)
    end

    def load_model(path)
      @model_file ||= create_tempfile
      # TODO ensure tempfile is still cleaned up
      FileUtils.cp(path, @model_file.path)
    end

    def self.finalize(pointer)
      # must use proc instead of stabby lambda
      proc { FFI.XLearnHandleFree(pointer) }
    end

    def self.finalize_file(file)
      # must use proc instead of stabby lambda
      proc do
        file.close
        file.unlink
      end
    end

    private

    def set_train_set(x, y)
      if x.is_a?(String)
        check_call FFI.XLearnSetTrain(@handle, x)
        check_call FFI.XLearnSetBool(@handle, "from_file", true)
      else
        train_set = DMatrix.new(x, label: y)
        check_call FFI.XLearnSetDMatrix(@handle, "train", train_set)
        check_call FFI.XLearnSetBool(@handle, "from_file", false)
      end
    end

    def set_params(params)
      params.each do |k, v|
        k = k.to_s
        ret =
          case k
          when "task", "metric", "opt", "log"
            FFI.XLearnSetStr(@handle, k, v)
          when "lr", "lambda", "init", "alpha", "beta", "lambda_1", "lambda_2"
            FFI.XLearnSetFloat(@handle, k, v)
          when "k", "epoch", "fold", "nthread", "block_size", "stop_window", "seed"
            FFI.XLearnSetInt(@handle, k, v)
          when "quiet", "on_disk", "bin_out", "norm", "lock_free", "early_stop", "sign", "sigmoid"
            FFI.XLearnSetBool(@handle, k, v)
          else
            raise ArgumentError, "Invalid parameter: #{k}"
          end
        check_call ret
      end
    end

    def create_tempfile
      file = Tempfile.new("xlearn")
      ObjectSpace.define_finalizer(self, self.class.finalize_file(file))
      file
    end
  end
end
