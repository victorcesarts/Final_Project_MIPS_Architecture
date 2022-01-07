import random
from random import randint
for WD3 in range (0, 256,1):
    WD3='{0:08x}'.format(WD3)
    for A1 in range(0,32,1):
        A1='{0:05b}'.format(A1)
        for A2 in reversed(range(0,32,1)):
            A2='{0:05b}'.format(A2)
            for A3 in range(0, 32):
                A3 = randint(0, 32) 
                A3='{0:05b}'.format(A3)
           
                with open("inputs.txt", "a") as arquivo:
                    arquivo.write(str(A1)+'\n')
                    arquivo.write(str(A2)+'\n')
                    arquivo.write(str(A3)+'\n')
                    arquivo.write(str(WD3)+'\n')
                    arquivo.write(str(0)+'\n')
                    arquivo.write(str(A1)+'\n')
                    arquivo.write(str(A2)+'\n')
                    arquivo.write(str(A3)+'\n')
                    arquivo.write(str(WD3)+'\n')
                    arquivo.write(str(1)+'\n')
print("done")
       