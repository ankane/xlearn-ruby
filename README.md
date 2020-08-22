# xLearn

[xLearn](https://github.com/aksnzhy/xlearn) - the high performance machine learning library - for Ruby

Supports:

- Linear models
- Factorization machines
- Field-aware factorization machines

[![Build Status](https://travis-ci.org/ankane/xlearn.svg?branch=master)](https://travis-ci.org/ankane/xlearn) [![Build status](https://ci.appveyor.com/api/projects/status/r7upg4073w7xct35/branch/master?svg=true)](https://ci.appveyor.com/project/ankane/xlearn/branch/master)

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'xlearn'
```

## Getting Started

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

Save a text version of the model

```ruby
model.save_txt("model.txt")
```

Pass a validation set

```ruby
model.fit(x_train, y_train, eval_set: [x_val, y_val])
```

Train online

```ruby
model.partial_fit(x_train, y_train)
```

Get the bias term, linear term, and latent factors

```ruby
model.bias_term
model.linear_term
model.latent_factors # fm and ffm only
```

## Parameters

Pass parameters - default values below

```ruby
XLearn::FM.new(
  task: "binary",      # binary (classification), reg (regression)
  metric: nil,         # acc, prec, recall, f1, auc, mae, mape, rmse, rmsd
  lr: 0.2,             # learning rate
  lambda: 0.00002,     # lambda for l2 regularization
  k: 4,                # latent factors for fm and ffm
  alpha: 0.3,          # hyper parameter for ftrl
  beta: 1.0,           # hyper parameter for ftrl
  lambda_1: 0.00001,   # hyper parameter for ftrl
  lambda_2: 0.00002,   # hyper parameter for ftrl
  epoch: 10,           # number of epochs
  fold: 3,             # number of folds
  opt: "adagrad",      # sgd, adagrad, ftrl
  block_size: 500,     # block size for on-disk training in MB
  early_stop: true,    # use early stopping
  stop_window: 2,      # size of stop window for early stopping
  sign: false,         # convert predition output to 0 and 1
  sigmoid: false,      # convert predition output using sigmoid
  seed: 1              # random seed to shuffle data set
)
```

## Cross-Validation

Cross-validation

```ruby
model.cv(x, y)
```

Specify the number of folds

```ruby
model.cv(x, y, folds: 5)
```

## Data

Data can be an array of arrays

```ruby
[[1, 2, 3], [4, 5, 6]]
```

Or a Numo array

```ruby
Numo::NArray.cast([[1, 2, 3], [4, 5, 6]])
```

Or a Rover data frame

```ruby
Rover.read_csv("houses.csv")
```

Or a Daru data frame

```ruby
Daru::DataFrame.from_csv("houses.csv")
```

## Performance

For large datasets, read data directly from files

```ruby
model.fit("train.txt", eval_set: "validate.txt")
model.predict("test.txt")
model.cv("train.txt")
```

For linear models and factorization machines, use CSV:

```txt
label,value_1,value_2,...,value_n
```

Or the `libsvm` format (better for sparse data):

```txt
label index_1:value_1 index_2:value_2 ... index_n:value_n
```

> You can also use commas instead of spaces for separators

For field-aware factorization machines, use the `libffm` format:

```txt
label field_1:index_1:value_1 field_2:index_2:value_2 ...
```

> You can also use commas instead of spaces for separators

You can also write predictions directly to a file

```ruby
model.predict("test.txt", out_path: "predictions.txt")
```

## Credits

This library is modeled after xLearn’s [Scikit-learn API](https://xlearn-doc.readthedocs.io/en/latest/python_api/index.html).

## History

View the [changelog](https://github.com/ankane/xlearn/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/xlearn/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/xlearn/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development and testing:

```sh
git clone https://github.com/ankane/xlearn.git
cd xlearn
bundle install
bundle exec rake vendor:all
bundle exec rake test
```
