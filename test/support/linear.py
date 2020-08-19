import xlearn as xl

# install xlearn from source for latest version

model = xl.LRModel(task="reg", nthread=1, opt="adagrad")
model.fit("test/support/data.csv")
print(model.predict("test/support/data.csv")[:5].tolist())
