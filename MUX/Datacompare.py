
for x in range(0,64,1):
    x='{0:032b}'.format(x)
    for y in range(0,64,1):
        y='{0:032b}'.format(y)
        
        with open("inputss.txt", "a") as arquivo:            
            arquivo.write(str(y)+'\n')
            arquivo.write(str(x)+'\n')

            