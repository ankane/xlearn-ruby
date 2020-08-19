require_relative "test_helper"

class XLearnTest < Minitest::Test
  def test_linear
    x = [[1, 2], [3, 4], [5, 6], [7, 8]]
    y = [1, 2, 3, 4]

    model = XLearn::Linear.new(task: "reg")
    model.fit(x, y, eval_set: [x, y])
    assert_elements_in_delta y, model.predict(x), 0.1

    assert model.bias_term
    assert model.linear_term

    model.save_model(temp_path("linear.bin"))
    model.save_txt(temp_path("linear.txt"))

    model2 = XLearn::Linear.new(task: "reg")
    model2.load_model(temp_path("linear.bin"))
    assert_elements_in_delta y, model2.predict(x), 0.1

    model.partial_fit(x, y)
  end

  def test_fm
    x = [[1, 2], [3, 4], [5, 6], [7, 8]]
    y = [1, 2, 3, 4]

    model = XLearn::FM.new(task: "reg")
    model.fit(x, y, eval_set: [x, y])

    model.save_txt(temp_path("fm.txt"))

    assert model.bias_term
    assert model.linear_term
    assert model.latent_factors
  end

  def test_ffm
    x = [[1, 2], [3, 4], [5, 6], [7, 8]]
    y = [1, 2, 3, 4]

    model = XLearn::FFM.new(task: "reg")
    model.fit(x, y, eval_set: [x, y])

    model.save_txt(temp_path("ffm.txt"))

    assert model.bias_term
    assert model.linear_term
    assert model.latent_factors
  end

  def test_cv
    model = XLearn::Linear.new(task: "reg", fold: 5)
    model.cv(data_path)
  end

  def test_predict_not_fit
    model = XLearn::Linear.new(task: "reg")
    error = assert_raises(XLearn::Error) do
      model.predict(data_path)
    end
    assert_equal "Not trained", error.message
  end

  def test_save_model_not_fit
    model = XLearn::Linear.new(task: "reg")
    error = assert_raises(XLearn::Error) do
      model.save_model("model.bin")
    end
    assert_equal "Not trained", error.message
  end

  def test_save_txt_not_fit
    model = XLearn::Linear.new(task: "reg")
    error = assert_raises(XLearn::Error) do
      model.save_txt("model.txt")
    end
    assert_equal "Not trained", error.message
  end

  def test_files
    model = XLearn::Linear.new(task: "reg")
    model.fit(data_path, eval_set: data_path)
    model.predict(data_path, out_path: temp_path("output.txt"))
  end

  def test_matrix
    require "matrix"

    x = Matrix[[1, 2], [3, 4], [5, 6], [7, 8]]
    y = Vector.elements([1, 2, 3, 4])

    model = XLearn::Linear.new(task: "reg")
    model.fit(x, y, eval_set: [x, y])
    assert_elements_in_delta y, model.predict(x), 0.1
  end

  def test_numo
    require "numo/narray"

    x = Numo::DFloat.cast([[1, 2], [3, 4], [5, 6], [7, 8]])
    y = Numo::DFloat.cast([1, 2, 3, 4])

    model = XLearn::Linear.new(task: "reg")
    model.fit(x, y, eval_set: [x, y])
    assert_elements_in_delta y, model.predict(x), 0.1
  end

  def test_daru
    require "daru"

    x = Daru::DataFrame.new(x1: [1, 3, 5, 7], x2: [2, 4, 6, 8])
    y = Daru::Vector.new([1, 2, 3, 4])

    model = XLearn::Linear.new(task: "reg")
    model.fit(x, y, eval_set: [x, y])
    assert_elements_in_delta y, model.predict(x), 0.1
  end

  def test_rover
    require "rover"

    x = Rover.read_csv(data_path, headers: %w(y x0 x1 x2 x3))
    y = x.delete("y")

    model = XLearn::Linear.new(task: "reg")
    model.fit(x, y, eval_set: [x, y])
    # TODO check against expected predictions
    assert_elements_in_delta y, model.predict(x), 1
  end

  def teardown
    delete_file("data.csv.bin")
    5.times do |i|
      delete_file("data.csv_#{i}")
    end
  end

  private

  def data_path
    "test/support/data.csv"
  end

  def temp_path(path)
    "#{Dir.tmpdir}/#{path}"
  end

  def delete_file(name)
    path = "test/support/#{name}"
    File.unlink(path) if File.exist?(path)
  end
end
