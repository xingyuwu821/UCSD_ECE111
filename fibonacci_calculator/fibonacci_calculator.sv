module fibonacci_calculator (input logic clk, reset_n,
                             input logic [4:0] input_s,
                             input logic begin_fibo,
                            output logic [15:0] fibo_out,
                            output logic done);

  enum logic [1:0] {IDLE=2'b00, COMPUTE=2'b01, DONE=2'b10} state;

  logic  [4:0] count;
  logic [15:0] R0, R1;

  always_ff @(posedge clk, negedge reset_n)
  begin
    if (!reset_n) begin
      state <= IDLE;
      done <= 0;
    end else
      case (state)
        IDLE:
          if (begin_fibo) begin
            count <= input_s;
            R0 <= 1;
            R1 <= 0;
            state <= COMPUTE;
          end
        COMPUTE:
          if (count > 1) begin
            count <= count - 1;
            R0 <= R0 + R1;
            R1 <= R0;
            $display("state = %s, count = %3d, R0 = %4d, R1 = %4d", state, count, R0, R1);
          end else begin
            state <= DONE;
            done <= 1;
            fibo_out <= R0;
          end
        DONE:
          state <= IDLE;
      endcase
  end
endmodule