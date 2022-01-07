
for x in range(0,65536,1):
    x='{0:016b}'.format(x)
    f_x = str(x)
    negative = "1111111111111111"
    positive = "0000000000000000"
    if (f_x[0] == "1"):
        f_x = "1111111111111111" + f_x
    else:
        f_x = "0000000000000000" + f_x
    print(f_x)
    with open("inputcompare.txt", "a") as arquivo:          
        arquivo.write(str(f_x)+'\n')


            