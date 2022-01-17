f = open("InstrandDataRF.txt", "r")
for x in f:
    with open("inputs.txt", "a") as arquivo:
        Instr = str(x)
        
        OP = (Instr[0: 6])
        OP = int(OP, base = 2)
        A1 = Instr[6: 11]
        A2 = Instr[11: 16]
        arquivo.write(str(A1) + '\n')
        arquivo.write(str(A2) + '\n')
        print(OP)
        print(Instr)
        print(A1)
        print(A2)
        if(OP == 0):
            A3 = Instr[16:21]
            arquivo.write(str(A3) + '\n')
            print(A3)
        elif (OP == 8 or OP == 9 or (OP >= 32 and OP <= 37)):
            A3 = Instr[16:21]
            arquivo.write(str(A3) + '\n')
            print(A3)
        else:
            A3 = "XX"
            arquivo.write(str(A3) + '\n')
            print(A3)
        if(OP == 2 or (OP >= 40 and OP <= 43)):
            WE3 = 0
            arquivo.write(str(WE3) + '\n')
        else:
            WE3 = 1
            arquivo.write(str(WE3) + '\n')
        
        