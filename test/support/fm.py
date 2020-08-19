import xlearn as xl
import pandas as pd

df = pd.read_csv('test/support/data.txt', sep=' ', names=['y', 'x0', 'x1', 'x2', 'x3'])

X = df.drop(columns=['y'])
y = df['y']

model = xl.FMModel(task='reg', nthread=1, opt='adagrad')
model.fit(X, y)
print('weights', model.weights)
print('predict', model.predict(X)[0:6].tolist())

model = xl.FMModel(task='reg', nthread=1, opt='adagrad')
model.fit('test/support/data.txt')
print('predict txt', model.predict('test/support/data.txt')[0:6].tolist())

model = xl.FMModel(task='reg', nthread=1, opt='adagrad')
model.fit('test/support/data.csv')
print('predict csv', model.predict('test/support/data.csv')[0:6].tolist())
