// FPGA Top Level

`default_nettype none

module top (
  // I/O ports
  input  logic hz100, reset,
  input  logic [20:0] pb,
  output logic [7:0] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue,

  // UART ports
  output logic [7:0] txdata,
  input  logic [7:0] rxdata,
  output logic txclk, rxclk,
  input  logic txready, rxready
);

	typedef enum logic [2:0] {
        INIT, NUM1, NUM2, FINAL
    } stateLog;

    stateLog currentState, nextState;

    logic keyStrobe;

    logic [31:0] r1Val, r2Val, nextR1Val, nextR2Val;
    logic [3:0] operation, nextOperation;
    
    logic [31:0] decOut;
    logic [4:0] dumpVar;

    keysync f1 (.clk(hz100), .keyin(pb[19:0]), .keyclk(keyStrobe), .rst(reset), .keyout(dumpVar));

    /*temporary test code for ss display*/

    ssdec f2 (.in(r1Val[3:0]), .enable(1'b1), .out(ss0[6:0]));
    ssdec f3 (.in(r1Val[7:4]), .enable(1'b1), .out(ss1[6:0]));
    ssdec f4 (.in(r1Val[3:0]), .enable(1'b1), .out(ss2[6:0]));
    ssdec f5 (.in(r1Val[7:4]), .enable(1'b1), .out(ss3[6:0]));

    ssdec f6 (.in(operation), .enable(1'b1), .out(ss5[6:0]));


    ////////////////////////////////

    always_ff@(posedge keyStrobe, negedge reset)
        if (~reset) begin
            currentState <= NUM1;
            r1Val <= 0;
            r2Val <= 0;
            operation <= 0;
        end
        else begin
            currentState <= nextState;
            r1Val <= nextR1Val;
            r2Val <= nextR2Val;
            operation <= nextOperation;
        end

    decoder f7 (.pbIn(pb[19:0]), .decOut(decOut));

    //li t6, 0x140  # load the immediate 0x140 (address) into register t6
    //sw t0, 0(t6)  # store the word in t0 to memory address in t6 with 0 byte offset   

        always_comb begin

        casez({currentState, |pb[10:0], |pb[20:17], pb[14], pb[12]}) //numbers, operation, equal, clear 

        
            // {INIT, 1'b0, 1'b0, 1'b0, 1'b0}: begin //calculator starts, immediately goes to the num1 state to start taking in numbers
            //     nextState = NUM1;
            //     nextR1Val = 0;
            //     nextR2Val = 0;
            //     nextOperation = 0;

            // end

            {NUM1, 1'b1, 1'b0, 1'b0, 1'b0}: begin //inputting numbers begins for num1
                nextState = NUM1;
                nextR1Val = decOut + (r1Val << 3) + (r1Val << 2);
                nextR2Val = 0; 
                nextOperation = 0;
            end

            {NUM1, 1'b0, 1'b1, 1'b0, 1'b0}: begin // operation button was pressed, thus moving on to num2 state
                
                nextState = NUM2;
                nextR1Val = r1Val;
                nextR2Val = r2Val;
                if (pb[19])
                    nextOperation = 4'b1000;
                else if (pb[18])
                    nextOperation = 4'b0100;
                else if (pb[17])
                    nextOperation = 4'b0010;
                else if (pb[16])
                    nextOperation = 4'b0001;
                else 
                    nextOperation = 4'b0000;

            end
            

            {NUM2, 1'b1, 1'b0, 1'b0, 1'b0}: begin //inputting numbers right now, will stay at state num2
            
                nextState = NUM2;
                nextR1Val = r1Val;
                nextR2Val = decOut + (r2Val << 3) + (r2Val << 2);
                nextOperation = operation;

            end
            
           {NUM2, 1'b0, 1'b0, 1'b1, 1'b0}: begin //the E (equal button was pressed, thus moving onto the calculation, next final state)
            
            nextState = FINAL; 
            nextR1Val = r1Val;
            nextR2Val = r2Val;
            nextOperation = operation;


           end

           {FINAL, 1'b1, 1'b0, 1'b0, 1'b1}: begin //the final state is on and the clear is pressed
            
            nextState = NUM1;
            nextR1Val = r1Val;
            nextR2Val = r2Val;
            nextOperation = operation;


           end

            {3'b???, 1'b0, 1'b0, 1'b0, 1'b1}: begin //from any state if the clear is pressed
            
            nextState = NUM1;
            nextR1Val = 0;
            nextR2Val = 0;
            nextOperation = 0;

           end

           default: begin
                nextState = currentState;
                nextR1Val = r1Val;
                nextR2Val = r2Val;
                nextOperation = operation;
           end

        endcase

        end

endmodule

module decoder (input logic [19:0] pbIn,
                output logic [31:0] decOut);

    always_comb begin
        if (pbIn[9])
            decOut = 32'b1001;
        else if (pbIn[8])
            decOut = 32'b1000;
        else if (pbIn[7])
            decOut = 32'b0111;
        else if (pbIn[6])
            decOut = 32'b0110;
        else if (pbIn[5])
            decOut = 32'b0101;
        else if (pbIn[4])
            decOut = 32'b0100;
        else if (pbIn[3])
            decOut = 32'b0011;
        else if (pbIn[2])
            decOut = 32'b0010;
        else if (pbIn[1])
            decOut = 32'b0001;
        else
            decOut = 0;
    end
endmodule