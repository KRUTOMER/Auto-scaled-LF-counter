# Auto-scaled-LF-counter
Auto-scaled low-frequency counter by "FPGA prototyping by Verilog examples" book

This is an Auto-scaled low-frequency counter, based on suggested experiment 6.5.5 of "FPGA prototyping by Verilog examples" book by Pong P. Chu.  
Module *counter* count period of *si* signal in microseconds.  
Module *division* finds out frequency of *si* signal by dividing 1 second (1_000_000) on *si*'s period.  
Module *BCD* converts binary representation of quentient to deciminal.  
Module *adjust* plase a dot symbol on 7-segment display.  
Module *LF_counter* is a master FSM that control modules *counter, division, BCD and adjust*.  
Module *7seg* covert final result of LF_counter and diplay it on 7-segment display.  
Module *reg* is a simple register, placed between *LF_counter* and *7seg* modules to reduse chance of metastability effect.  
Module *top* unite all modules in one.  

This is one of my first projects and I hope for some feedback about my verilog code.
