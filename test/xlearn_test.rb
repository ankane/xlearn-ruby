require_relative "test_helper"

class XLearnTest < Minitest::Test
  def setup
    delete_file("data.csv.bin")
    5.times do |i|
      delete_file("data.csv_#{i}")
    end
  end

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
    model.cv("test/support/data.csv")
  end

  def test_files
    path = "test/support/data.csv"
    model = XLearn::Linear.new(task: "reg")
    model.fit(path, eval_set: path)
    model.predict(path, out_path: temp_path("output.txt"))
  end

  def test_result_linear
    path = "test/support/data.csv"
    model = XLearn::Linear.new(task: "reg", nthread: 1)
    model.fit(path)
    predictions = model.predict(path)
    expected = [0.9222735166549683, 0.8694016933441162, 0.7055330276489258, 0.5149608850479126, 0.6284207701683044]
    assert_elements_in_delta expected, predictions.first(5)
  end

  def test_result_fm
    path = "test/support/data.csv"
    model = XLearn::FM.new(task: "reg", nthread: 1)
    model.fit(path)
    predictions = model.predict(path)
    expected = [1.026936650276184, 1.0957672595977783, 1.0505752563476562, 1.1147269010543823, 1.0406986474990845]
    assert_elements_in_delta expected, predictions.first(5)
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

  private

  def temp_path(path)
    "#{Dir.tmpdir}/#{path}"
  end

  def delete_file(name)
    path = "test/support/#{name}"
    File.unlink(path) if File.exist?(path)
  end
end
