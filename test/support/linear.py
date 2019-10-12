import xlearn as xl

model = xl.LRModel(task="reg")
model.fit("test/data/boston/boston.csv")
print(model.predict("test/data/boston/boston.csv")[:5])
