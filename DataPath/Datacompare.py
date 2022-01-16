def functF(Funct, ALUop):
        if ALUop == 00:
            AluControl = "010"
        elif ALUop == "01":
            AluControl = "110"
        elif ALUop == "10":  
            if Funct == 32:
                AluControl = "010"
            elif Funct == 34:
                AluControl = "110"
            elif Funct == 36:
                AluControl = "000"
            elif Funct == 37:
                AluControl = "001"
            elif Funct == 42:
                AluControl = "111"
        else:
            AluControl = "XXX"
        return AluControl
def writing():
    f = open("InstrandData.txt", "r")
    count = 1
    for x in f:
        with open("inputs.txt", "a") as arquivo:
            arquivo.write(str(x))
            if count % 2 == 0:
                y = str(x)
                OP = (y[0: 6])
                OP = int(OP, base = 2)
                Funct = y[26: 32]
                Funct = int(Funct, base = 2)
                print(Funct)
                if OP == 0:
                    RegWriteM = 1
                    RegDstM = "01"
                    AluSrcM = 0
                    MemToRegM = 0    
                    ALUopM = 10
                    jumpM = 0
                    arquivo.write(str(RegWriteM) + '\n') 
                    arquivo.write(str(RegDstM) + '\n') 
                    arquivo.write(str(AluSrcM) + '\n') 
                    arquivo.write(str(MemToRegM) + '\n') 
                    b = functF(Funct, ALUopM)
                    arquivo.write(str(b) + '\n') 
                    arquivo.write(str(jumpM) + '\n') 
                    arquivo.write(str("0") + '\n') 
                                
                elif OP == 3:
                    RegWriteM = 1
                    RegDstM = "10"
                    AluSrcM = 0
                    MemToRegM = 0    
                    ALUopM = 10 
                    jumpM = 0
                    arquivo.write(str(RegWriteM) + '\n') 
                    arquivo.write(str(RegDstM) + '\n') 
                    arquivo.write(str(AluSrcM) + '\n') 
                    arquivo.write(str(MemToRegM) + '\n') 
                    b = functF(Funct, ALUopM)
                    arquivo.write(str(b) + '\n') 
                    arquivo.write(str(jumpM) + '\n') 
                    arquivo.write(str("0") + '\n') 
                                
                elif OP >= 32 and OP <= 37: 
                    RegWriteM = 1
                    RegDstM = "00"
                    AluSrcM = 1
                    MemToRegM = 1   
                    ALUopM = 00 
                    jumpM = 0
                    arquivo.write(str(RegWriteM) + '\n') 
                    arquivo.write(str(RegDstM) + '\n') 
                    arquivo.write(str(AluSrcM) + '\n') 
                    arquivo.write(str(MemToRegM) + '\n') 
                    b = functF(Funct, ALUopM)
                    arquivo.write(str(b) + '\n')                     
                    arquivo.write(str(jumpM) + '\n') 
                    arquivo.write(str("0") + '\n') 
               
                elif OP >= 40 and OP <= 43: 
                    RegWriteM = 0
                    RegDstM = "XX"
                    AluSrcM = 1
                    MemToRegM = "X"  
                    ALUopM = 00 
                    jumpM = 0
                    arquivo.write(str(RegWriteM) + '\n') 
                    arquivo.write(str(RegDstM) + '\n') 
                    arquivo.write(str(AluSrcM) + '\n') 
                    arquivo.write(str(MemToRegM) + '\n') 
                    b = functF(Funct, ALUopM)
                    arquivo.write(str(b) + '\n') 
                    arquivo.write(str(jumpM) + '\n') 
                    arquivo.write(str("0") + '\n') 
               
                elif OP == 8 or OP == 9: 
                    RegWriteM = 1
                    RegDstM = "00"
                    AluSrcM = 1
                    MemToRegM = 0  
                    ALUopM = 00 
                    jumpM = 0
                    arquivo.write(str(RegWriteM) + '\n') 
                    arquivo.write(str(RegDstM) + '\n') 
                    arquivo.write(str(AluSrcM) + '\n') 
                    arquivo.write(str(MemToRegM) + '\n') 
                    b = functF(Funct, ALUopM)
                    arquivo.write(str(b) + '\n')  
                    arquivo.write(str(jumpM) + '\n') 
                    arquivo.write(str("0") + '\n') 
                
                elif OP == 2: 
                    RegWriteM = 0
                    RegDstM = "XX"
                    AluSrcM = "X"
                    MemToRegM = "X"
                    ALUopM = "XX"
                    jumpM = 1
                    arquivo.write(str(RegWriteM) + '\n') 
                    arquivo.write(str(RegDstM) + '\n') 
                    arquivo.write(str(AluSrcM) + '\n') 
                    arquivo.write(str(MemToRegM) + '\n') 
                    b = functF(Funct, ALUopM)
                    arquivo.write(str(b) + '\n') 
                    arquivo.write(str(jumpM) + '\n') 
                    arquivo.write(str("0") + '\n') 
                 
                else:
                    RegWriteM = "X"
                    RegDstM = "XX"
                    AluSrcM = "X"
                    MemToRegM = "X"
                    ALUopM = "XX"
                    jumpM = "X"
                    arquivo.write(str(RegWriteM) + '\n') 
                    arquivo.write(str(RegDstM) + '\n') 
                    arquivo.write(str(AluSrcM) + '\n') 
                    arquivo.write(str(MemToRegM) + '\n') 
                    b = functF(Funct, ALUopM)
                    arquivo.write(str(b) + '\n') 
                    arquivo.write(str(jumpM) + '\n') 
                    arquivo.write(str("0") + '\n') 
            count = count + 1
    return None
b = writing()
print(b)