import xlearn as xl

model = xl.LRModel(task="reg")
model.fit("test/support/data.csv")
print(model.predict("test/support/data.csv")[:5].tolist())
