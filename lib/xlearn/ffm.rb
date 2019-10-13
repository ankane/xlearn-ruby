module XLearn
  class FFM < Model
    def initialize(**options)
      @model_type = "ffm"
      super
    end

    def latent_factor
      factor = []
      current = -1
      read_txt do |line|
        if line.start_with?("v_")
          parts = line.split(": ")
          i = parts.first.split("_")[1].to_i
          if i != current
            factor << []
            current = i
          end
          factor.last << parts.last.split(" ").map(&:to_f)
        end
      end
      factor
    end
  end
end
