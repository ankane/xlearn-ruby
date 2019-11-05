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
    extern "int XLearnCreate(char *model_type, XL *out)"
    extern "int XlearnCreateDataFromMat(real_t* data, index_t nrow, index_t ncol, real_t* label, index_t* field_map, DataHandle* out)"
    extern "int XlearnDataFree(DataHandle* out)"
    extern "int XLearnHandleFree(XL *out)"
    extern "int XLearnShow(XL *out)"
    extern "int XLearnSetTrain(XL *out, char *train_path)"
    extern "int XLearnSetTest(XL *out, char *test_path)"
    extern "int XLearnSetPreModel(XL *out, char *pre_model_path)"
    extern "int XLearnSetValidate(XL *out, char *val_path)"
    extern "int XLearnSetTXTModel(XL *out, char *model_path)"
    extern "int XLearnFit(XL *out, char *model_path)"
    extern "int XLearnCV(XL *out)"
    extern "int XLearnPredictForMat(XL *out, char *model_path, uint64 *length, float** out_arr)"
    extern "int XLearnPredictForFile(XL *out, char *model_path, char *out_path)"
    extern "int XLearnSetDMatrix(XL *out, char *key, DataHandle *out_data)"
    extern "int XLearnSetStr(XL *out, char *key, char *value)"
    extern "int XLearnSetInt(XL *out, char *key, int value)"
    extern "int XLearnGetInt(XL *out, char *key, int *value)"
    extern "int XLearnSetFloat(XL *out, char *key, float value)"
    extern "int XLearnGetFloat(XL *out, char *key, float *value)"
    extern "int XLearnSetBool(XL *out, char *key, bool value)"
    extern "int XLearnGetBool(XL *out, char *key, bool *value)"
  end
end
