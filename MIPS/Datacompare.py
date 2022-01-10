import random
from random import randint
for ReadData in range (0, 34,1):
    ReadData = randint(0, 34)
    ReadData='{0:08x}'.format(ReadData)         
    with open("inputs.txt", "a") as arquivo:
        arquivo.write(str(ReadData)+'\n')
print("done")