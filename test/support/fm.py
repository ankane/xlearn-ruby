import xlearn as xl

# install xlearn from source for latest version

model = xl.FMModel(task="reg", nthread=1)
model.fit("test/support/data.csv")
print(model.predict("test/support/data.csv")[:5].tolist())
