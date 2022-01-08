count = 0
for x in range(4194304,4194448,4):
    x='{0:08x}'.format(x)
    print(x)    
    with open("inputss.txt", "a") as arquivo: 
        arquivo.write(str(x)+'\n')
