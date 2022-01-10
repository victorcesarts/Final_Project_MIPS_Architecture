
def writing():
    f = open("InstrandData.txt", "r")
    count = 1
    
    for x in f:
        with open("inputs.txt", "a") as arquivo:
            if count % 2 == 0:
                y = str(x)
                OP = (y[0: 6])
                Funct = y[26: 32]
                print(Funct)
                arquivo.write(str(OP)+ '\n')
                arquivo.write(str(Funct)+ '\n')
                arquivo.write(str("0")+ '\n')
            count = count + 1
    return None
b = writing()
print(b)