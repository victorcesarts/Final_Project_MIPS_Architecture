
for x in range(0,16,1):
    x='{0:032b}'.format(x)
    for y in range(0,32,16):
        y='{0:032b}'.format(y)
        f_x=int(x,2) & int(y,2)
        g_x=int(x,2) | int(y,2)
        h_x=int(x,2) + int(y,2)
        j_x=int(x,2) - int(y,2)
        if (int(j_x) < 0):
            number = abs(j_x)
            binary_number = '{0:032b}'.format(number)
            flipped_binary_number = ''
            one = "00000000000000000000000000000001"
            for i in binary_number:
    
                if i == '0':
                    flipped_binary_number += '1'
          
                else:
                    flipped_binary_number += '0'
            sum = bin(int(flipped_binary_number, 2) + int(one, 2)) 
            flipped_binary_number = sum[2:]
            str_twos_complement = str(flipped_binary_number)
            j_x = int(str_twos_complement, 2)
    w_x=int(x,32) < int(y,32)
    f_x='{0:032b}'.format(f_x)
    g_x='{0:032b}'.format(g_x)
    h_x='{0:032b}'.format(h_x)
    j_x='{0:032b}'.format(j_x)
    w_x='{0:032b}'.format(w_x)
    with open("inputs.txt", "a") as arquivo:
        """ arquivo.write(str("000")+'\n')
        arquivo.write(str(x)+'\n')
        arquivo.write(str(y)+'\n')
        arquivo.write(str("001")+'\n')
        arquivo.write(str(x)+'\n')
        arquivo.write(str(y)+'\n')
        arquivo.write(str("010")+'\n')
        arquivo.write(str(x)+'\n')
        arquivo.write(str(y)+'\n')
        arquivo.write(str("110")+'\n')
        arquivo.write(str(x)+'\n')
        arquivo.write(str(y)+'\n')
        arquivo.write(str("111")+'\n')
        arquivo.write(str(x)+'\n')
        arquivo.write(str(y)+'\n')  """

        arquivo.write(str(f_x)+'\n')
        if ((int(f_x) == 0)):
            ZERO = 1
        else:
            ZERO = 0
        arquivo.write(str(ZERO)+'\n')
        arquivo.write(str(g_x)+'\n')
        if ((int(g_x) == 0)):
            ZERO = 1
        else:
            ZERO = 0
        arquivo.write(str(ZERO)+'\n')
        arquivo.write(str(h_x)+'\n')
        if (int(h_x) == 0):
            ZERO = 1
        else:
            ZERO = 0
        arquivo.write(str(ZERO)+'\n')
        arquivo.write(str(j_x)+'\n')
        if (int(j_x) == 0):
            ZERO = 1
        else:
            ZERO = 0
        arquivo.write(str(ZERO)+'\n')
        arquivo.write(str(w_x)+'\n')
        if (int(w_x) == 0):
            ZERO = 1
        else:
            ZERO = 0
        arquivo.write(str(ZERO)+'\n')