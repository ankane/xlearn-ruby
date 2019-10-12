require_relative "test_helper"

class XLearnTest < Minitest::Test
  def test_works
    x = [[1, 2], [3, 4], [5, 6], [7, 8]]
    y = [1, 2, 3, 4]

    model = XLearn::Linear.new(task: "reg")
    model.fit(x, y, eval_set: [x, y])
    assert_elements_in_delta y, model.predict(x), 0.05

    model.save_model("/tmp/model.bin")

    model2 = XLearn::Linear.new(task: "reg")
    model2.load_model("/tmp/model.bin")
    assert_elements_in_delta y, model2.predict(x), 0.05
  end

  def test_files
    path = "test/data/boston/boston.csv"
    model = XLearn::Linear.new(task: "reg")
    model.fit(path, eval_set: path)
    model.predict(path, out_path: "/tmp/output.txt")
  end
end
