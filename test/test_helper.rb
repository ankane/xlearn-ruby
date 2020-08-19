require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"

class Minitest::Test
  def assert_elements_in_delta(expected, actual, delta = 0.001)
    assert_equal expected.size, actual.size
    expected.to_a.zip(actual.to_a) do |exp, act|
      assert_in_delta exp, act, delta
    end
  end
end
