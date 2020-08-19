module XLearn
  class FM < Model
    def initialize(
      task: "binary", metric: "auc", block_size: 500,
      lr: 0.2, k: 4, lambda: 0.1, init: 0.1, fold: 1, epoch: 5, stop_window: 2,
      opt: "sgd", nthread: 4, alpha: 1, beta: 1, lambda_1: 1, lambda_2: 1,
      seed: 1
    )

      @model_type = "fm"
      super
    end

    # shape is [i, k]
    # for v_{i}
    def latent_factors
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
