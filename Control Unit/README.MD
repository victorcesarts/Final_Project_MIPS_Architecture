# Control Unit
The control unit have two components: Main Decoder and ALU Decoder. The description in VHDL of these components can be found in files ControlUnit.vhd, MainDecoder.vhd and ALUDecoder.vhd. Futher, there are five .txt files:

inputop.txt: has the values of the Opcode input, which lenght is 6 bits;
inputFunct.txt: has the values of the Funct input, which lenght is 6 bits;
inputcompare.txt: has the expected values of the outputs, it'll be useful for checking the outputs;
output.txt: has the obtained values from circuit;
outputdata_comp.txt: if the compare between "inputcompare" and "output" are ok, "Good" is written, else, "Error" is written;

![image](https://user-images.githubusercontent.com/83244223/147271220-e3a13c1b-4d8f-45ed-a638-e5f5aab733d8.png)
