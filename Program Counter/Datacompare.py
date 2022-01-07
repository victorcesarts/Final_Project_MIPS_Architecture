count = 0
for x in range(4194304,4524163,1):
    count = count + 1
    x='{0:032b}'.format(x)
    if (count >= 400 and count <= 432):
        print("00000000010000000000000000000000")
    else:
        print(x)    
    with open("inputss.txt", "a") as arquivo: 
        if (count >= 400 and count <= 432):         
            arquivo.write(str("00000000010000000000000000000000")+'\n')
        else:
            arquivo.write(str(x)+'\n')
