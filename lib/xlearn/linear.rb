module XLearn
  class Linear < Model
    def initialize(**options)
      @model_type = "linear"
      super
    end
  end
end
