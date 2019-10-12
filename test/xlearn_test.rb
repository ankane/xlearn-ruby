require_relative "test_helper"

class XLearnTest < Minitest::Test
  def test_linear
    x = [[1, 2], [3, 4], [5, 6], [7, 8]]
    y = [1, 2, 3, 4]

    model = XLearn::Linear.new(task: "reg")
    model.fit(x, y, eval_set: [x, y])
    assert_elements_in_delta y, model.predict(x), 0.1

    model.save_model("/tmp/model.bin")
    model.save_txt("/tmp/model.txt")

    model2 = XLearn::Linear.new(task: "reg")
    model2.load_model("/tmp/model.bin")
    assert_elements_in_delta y, model2.predict(x), 0.1
  end

  def test_cv
    model = XLearn::Linear.new(task: "reg")
    model.cv("test/data/boston/boston.csv")
  end

  def test_files
    path = "test/data/boston/boston.csv"
    model = XLearn::Linear.new(task: "reg")
    model.fit(path, eval_set: path)
    model.predict(path, out_path: "/tmp/output.txt")
  end

  def test_matrix
    x = Matrix[[1, 2], [3, 4], [5, 6], [7, 8]]
    y = Vector.elements([1, 2, 3, 4])

    model = XLearn::Linear.new(task: "reg")
    model.fit(x, y, eval_set: [x, y])
    assert_elements_in_delta y, model.predict(x), 0.1
  end

  def test_numo
    x = Numo::DFloat.cast([[1, 2], [3, 4], [5, 6], [7, 8]])
    y = Numo::DFloat.cast([1, 2, 3, 4])

    model = XLearn::Linear.new(task: "reg")
    model.fit(x, y, eval_set: [x, y])
    assert_elements_in_delta y, model.predict(x), 0.1
  end

  def test_daru
    x = Daru::DataFrame.new(x1: [1, 3, 5, 7], x2: [2, 4, 6, 8])
    y = Daru::Vector.new([1, 2, 3, 4])

    model = XLearn::Linear.new(task: "reg")
    model.fit(x, y, eval_set: [x, y])
    assert_elements_in_delta y, model.predict(x), 0.1
  end
end
