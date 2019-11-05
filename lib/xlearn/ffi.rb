module XLearn
  module FFI
    extend Fiddle::Importer

    libs = XLearn.ffi_lib.dup
    begin
      dlload libs.shift
    rescue Fiddle::DLError => e
      retry if libs.any?
      raise e if ENV["XLEARN_DEBUG"]
      raise LoadError, "Could not find xLearn"
    end

    # https://github.com/aksnzhy/xlearn/blob/master/src/c_api/c_api.h
    # keep same order

    typealias "bool", "int"
    typealias "index_t", "unsigned int"
    typealias "XL", "void*"
    typealias "DataHandle", "void*"

    extern "int XLearnHello()"
    extern "int XLearnCreate(const char *model_type, XL *out)"
    extern "int XlearnCreateDataFromMat(const real_t* data, index_t nrow, index_t ncol, const real_t* label, index_t* field_map, DataHandle* out)"
    extern "int XlearnDataFree(DataHandle* out)"
    extern "int XLearnHandleFree(XL *out)"
    extern "int XLearnShow(XL *out)"
    extern "int XLearnSetTrain(XL *out, const char *train_path)"
    extern "int XLearnSetTest(XL *out, const char *test_path)"
    extern "int XLearnSetPreModel(XL *out, const char *pre_model_path)"
    extern "int XLearnSetValidate(XL *out, const char *val_path)"
    extern "int XLearnSetTXTModel(XL *out, const char *model_path)"
    extern "int XLearnFit(XL *out, const char *model_path)"
    extern "int XLearnCV(XL *out)"
    extern "int XLearnPredictForMat(XL *out, const char *model_path, uint64 *length, const float** out_arr)"
    extern "int XLearnPredictForFile(XL *out, const char *model_path, const char *out_path)"
    extern "int XLearnSetDMatrix(XL *out, const char *key, DataHandle *out_data)"
    extern "int XLearnSetStr(XL *out, const char *key, const char *value)"
    extern "int XLearnSetInt(XL *out, const char *key, int value)" # removed const
    extern "int XLearnGetInt(XL *out, const char *key, int *value)"
    extern "int XLearnSetFloat(XL *out, const char *key, float value)" # removed const
    extern "int XLearnGetFloat(XL *out, const char *key, float *value)"
    extern "int XLearnSetBool(XL *out, const char *key, bool value)" # removed const
    extern "int XLearnGetBool(XL *out, const char *key, bool *value)"
  end
end
