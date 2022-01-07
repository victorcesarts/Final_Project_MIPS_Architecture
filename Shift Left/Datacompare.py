
for x in range(0,1024,1):
    x='{0:032b}'.format(x)
    f_x = int(x,2)*4
    f_x='{0:032b}'.format(f_x)
    print(f_x)
    with open("inputcompare.txt", "a") as arquivo:          
        arquivo.write(str(f_x)+'\n')


            