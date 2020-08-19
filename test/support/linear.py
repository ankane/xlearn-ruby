import xlearn as xl
import pandas as pd

df = pd.read_csv('test/support/data.csv', sep=' ', names=['y', 'x0', 'x1', 'x2', 'x3'])

X = df.drop(columns=['y'])
y = df['y']

model = xl.LRModel(task='reg', nthread=1, opt='adagrad')
model.fit(X, y)
print('predict', model.predict(X)[0:6].tolist())

model = xl.LRModel(task='reg', nthread=1, opt='adagrad')
model.fit('test/support/data.csv')
print('predict', model.predict('test/support/data.csv')[0:6].tolist())
