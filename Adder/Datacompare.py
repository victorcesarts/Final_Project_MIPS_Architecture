
for x in range(0,64,1):
    x='{0:032b}'.format(x)
    for y in range(0,64,1):
        y='{0:032b}'.format(y)
        Add = int(x,2) + int(y,2)
        with open("inputss.txt", "a") as arquivo:
            Add='{0:032b}'.format(Add)            
            arquivo.write(str(Add)+'\n')

            