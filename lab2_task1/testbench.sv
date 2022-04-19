module testbench();
  logic        clk, reset;
  logic        left, right, sign, la, lb, lc, ra, rb, rc;
  logic [5:0]  expected;
  logic [31:0] vectornum, errors;
  logic [8:0]  testvectors[10000:0];
// инстанцировать тестируемое устройство
lab2_task1 dut(clk, reset, left, right, sign, la, lb, lc, ra, rb, rc);
// generate clock
always begin
    clk=1; #5; clk=0; #5;
  end
// на старте теста, загрузите вектора и запустите сброс
initial
  begin
    $readmemb("thunderbird.tv", testvectors);
    vectornum = 0; errors = 0; reset = 1; #22; reset = 0;
  end
// применение тестовых векторов по нарастающему фронту тактового сигнала
always @(posedge clk)
  begin
    #1; {left, right, sign, expected} = testvectors[vectornum];
  end
always @(negedge clk)
  if (~reset) begin    // skip during reset
    if ({la, lb, lc, ra, rb, rc} !== expected) begin // check result
      $display("Error: inputs = %b", {left, right,sign});
      $display(" outputs = %b %b %b %b %b %b (%b expected)",
        la, lb, lc, ra, rb, rc, expected);
      errors = errors + 1;
end
    vectornum = vectornum + 1;
    if (testvectors[vectornum] === 9'bx) begin
      $display("%d tests completed with %d errors", vectornum, errors);
$stop; end
  end
endmodule