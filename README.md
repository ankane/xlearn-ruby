# xLearn

[xLearn](https://github.com/aksnzhy/xlearn) - the high performance machine learning library - for Ruby

:fire: Uses the C API for blazing performance

Supports:

- Linear models
- Factorization machines
- Field-aware factorization machines

[![Build Status](https://travis-ci.org/ankane/xlearn.svg?branch=master)](https://travis-ci.org/ankane/xlearn)

## Installation

First, [install xLearn](https://xlearn-doc.readthedocs.io/en/latest/install/index.html). On Mac, copy `build/lib/libxlearn_api.dylib` to `/usr/local/lib`.

Add this line to your application’s Gemfile:

```ruby
gem 'xlearn'
```

## Getting Started

This library is modeled after the [Python Scikit-learn API](https://xlearn-doc.readthedocs.io/en/latest/python_api/index.html)

Prep your data

```ruby
x = [[1, 2], [3, 4], [5, 6], [7, 8]]
y = [1, 2, 3, 4]
```

Train a model

```ruby
model = XLearn::Linear.new(task: "reg")
model.fit(x, y)
```

Use `XLearn::FM` for factorization machines and `XLearn::FFM` for field-aware factorization machines

Make predictions

```ruby
model.predict(x)
```

Save the model to a file

```ruby
model.save_model("model.bin")
```

Load the model from a file

```ruby
model.load_model("model.bin")
```

Save a text version of the model [master]

```ruby
model.save_txt("model.txt")
```

## Cross-Validation [master]

```ruby
model.cv(x, y)
```

## Parameters

Specify parameters

```ruby
model = XLearn::FM.new(k: 20, epoch: 50)
```

Supports the same parameters as [Python](https://xlearn-doc.readthedocs.io/en/latest/all_api/index.html)

## Validation

Pass a validation set when fitting

```ruby
model.fit(x_train, y_train, eval_set: [x_val, y_val])
```

## Data

Data can be an array of arrays

```ruby
[[1, 2, 3], [4, 5, 6]]
```

Or a Daru data frame

```ruby
Daru::DataFrame.from_csv("houses.csv")
```

Or a Numo NArray

```ruby
Numo::DFloat.new(3, 2).seq
```

For performance, you can read data directly from files

```ruby
model.fit("train.txt", eval_set: "validate.txt")
model.predict("test.txt")
model.cv("train.txt")
```

[These formats](https://xlearn-doc.readthedocs.io/en/latest/python_api/index.html#choose-machine-learning-algorithm) are supported

You can also write predictions directly to a file

```ruby
model.predict("test.txt", out_path: "predictions.txt")
```

## History

View the [changelog](https://github.com/ankane/xlearn/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/xlearn/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/xlearn/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features
