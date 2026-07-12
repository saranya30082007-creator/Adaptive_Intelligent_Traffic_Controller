// Code your testbench here
// or browse Examples

module traffic_tb();
  reg clk,reset,emergency_req,pedestrian_req,night_req,fault_req,ns_heavy,ew_heavy;
  wire ns_red,ns_yellow,ns_green,ew_red,ew_yellow,ew_green;
  wire [3:0] state;

  traffic_fsm DUT(clk,reset,emergency_req,pedestrian_req,night_req,fault_req,ns_heavy,ew_heavy,ns_red,ns_yellow,ns_green,ew_red,ew_yellow,ew_green,state);

  always #5 clk=~clk;
  initial
	begin

      $dumpfile("dump.vcd");
      $dumpvars(1);

      //----------------------------------------------------------
      // Test Case 1 : System Reset
      //----------------------------------------------------------

      $display("\n==============================================");
      $display("TEST CASE 1 : SYSTEM RESET");
      $display("==============================================");

      clk = 0;
      reset = 1;

      emergency_req = 0;
      pedestrian_req = 0;
      night_req = 0;
      fault_req = 0;

      ns_heavy = 0;
      ew_heavy = 0;

      #10;
      reset = 0;

      //----------------------------------------------------------
      // Test Case 2 : Pedestrian Request
      //----------------------------------------------------------

      #20;
      $display("\n==============================================");
      $display("TEST CASE 2 : PEDESTRIAN REQUEST");
      $display("==============================================");

      pedestrian_req = 1;
      #40;
      pedestrian_req = 0;

      //----------------------------------------------------------
      // Test Case 3 : Night Mode
      //----------------------------------------------------------

      $display("\n==============================================");
      $display("TEST CASE 3 : NIGHT MODE");
      $display("==============================================");

      night_req = 1;
      #40;
      night_req = 0;

      //----------------------------------------------------------
      // Test Case 4 : Emergency Vehicle
      //----------------------------------------------------------

      $display("\n==============================================");
      $display("TEST CASE 4 : EMERGENCY VEHICLE");
      $display("==============================================");

      emergency_req = 1;
      #40;
      emergency_req = 0;

      //----------------------------------------------------------
      // Test Case 5 : Fault Mode
      //----------------------------------------------------------

      $display("\n==============================================");
      $display("TEST CASE 5 : FAULT MODE");
      $display("==============================================");

      fault_req = 1;
      #40;

      $display("\n==============================================");
      $display("SIMULATION COMPLETED SUCCESSFULLY");
      $display("==============================================");

      // ==============================================
      // TEST CASE 6 : EMERGENCY vs PEDESTRIAN PRIORITY
      // Expected: Emergency should have higher priority
      // ==============================================

      $display("\n==============================================");
      $display("TEST CASE 6 : EMERGENCY vs PEDESTRIAN PRIORITY");
      $display("==============================================");

      fault_req = 0;
      night_req = 0;
      pedestrian_req = 1;
      emergency_req = 1;

      #40;

      pedestrian_req = 0;
      emergency_req = 0;
      
      // ==============================================
      // TEST CASE 7 : FAULT vs EMERGENCY PRIORITY
      // Expected: Fault should have highest priority
      // ==============================================

      $display("\n==============================================");
      $display("TEST CASE 7 : FAULT vs EMERGENCY PRIORITY");
      $display("==============================================");

      emergency_req = 1;
      fault_req = 1;

      #40;

      emergency_req = 0;
      fault_req = 0;
      
      $display("\n==============================================");
      $display("SIMULATION COMPLETED SUCCESSFULLY");
      $display("==============================================");
      $finish;
    end
  initial
    begin
      $monitor($time," State=%b | NS[R=%b Y=%b G=%b] | EW[R=%b Y=%b G=%b] | Emergency=%b,Pedestrian=%b Night=%b Fault=%b",
             state,ns_red,ns_yellow,ns_green,ew_red,ew_yellow,ew_green,emergency_req,pedestrian_req,night_req,fault_req);
    end
endmodule
