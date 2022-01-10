for x in range(4194304,4524163,4):
    x='{0:08x}'.format(x)
    print(x)    
    with open("inputss.txt", "a") as arquivo: 
        arquivo.write(str(x)+'\n')