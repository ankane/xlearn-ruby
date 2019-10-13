module XLearn
  class FM < Model
    def initialize(**options)
      @model_type = "fm"
      super
    end

    def latent_factor
      factor = []
      read_txt do |line|
        if line.start_with?("v_")
          factor << line.split(": ").last.split(" ").map(&:to_f)
        end
      end
      factor
    end
  end
end
