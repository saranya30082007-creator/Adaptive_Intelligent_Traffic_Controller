// Code your design here

module traffic_fsm(clk,reset,emergency_req,pedestrian_req,night_req,fault_req,ns_heavy,ew_heavy,ns_red,ns_yellow,ns_green,ew_red,ew_yellow,ew_green,state);  
  input clk,reset,emergency_req,pedestrian_req,night_req,fault_req,ns_heavy,ew_heavy;
  output reg ns_red,ns_yellow,ns_green,ew_red,ew_yellow,ew_green;
  output reg[3:0] state;
  
  reg [3:0] next_state;
  reg [5:0] timer;
  parameter S_NS_Green=4'b0000;  // North and South Green light
  parameter S_NS_Yellow=4'b0001; // North and South Yellow
  parameter S_EW_Green=4'b0010;  // East and West Green
  parameter S_EW_Yellow=4'b0011; // East and West Yellow
  parameter S_All_Red=4'b0100;   // Safety gap before changing direction
  parameter S_Pedestrian=4'b0101; // Pedestrian crossing
  parameter S_Night=4'b0110;      // Night Mode
  parameter S_Emergency=4'b0111;  // Emergency priority
  parameter S_Fault=4'b1000;      // Fault/Maintance (traffic lights) mode
  
  // State Register
  // Updates current state at every positive clock edge
  
  always@(posedge clk or posedge reset)
    begin
      if(reset)
        begin
          state<=S_NS_Green;
          timer<=20;
        end
      else
        begin
          state<=next_state;
          if(timer>0)
            timer<=timer-1;
        end
    end
  
  // Next-state logic
  // Determines the next state based on current state and priority requests
  // Priority: Fault > Emergency > Pedestrian > Night > Normal 
  
  always @(*)
    begin
      next_state=state;
  
      // Highest Priority : Fault Mode
      // Keeps the controller in fault state
      
      if(fault_req)
        next_state=S_Fault;
      
      // Emergency Vehicle Handling
      // Safely transitions through Yellow and All-Red before giving priority to emergency vehicles.
      
      else if(emergency_req)
        begin
          if(state==S_NS_Green)
            next_state=S_NS_Yellow;
          else if (state==S_EW_Green)
            next_state=S_EW_Yellow;
          else if(state==S_NS_Yellow||state==S_EW_Yellow)
            next_state=S_All_Red;
          else
            next_state=S_Emergency;
        end
      
      // Pedestrian Crossing Request
      // Allows pedestrians only after safely stopping traffic.  
      
      else if(pedestrian_req)
        begin
          if(state==S_NS_Green)
            next_state=S_NS_Yellow;
          else if (state==S_EW_Green)
            next_state=S_EW_Yellow;
          else if(state==S_NS_Yellow||state==S_EW_Yellow)
            next_state=S_All_Red;
          else
            next_state=S_Pedestrian;
        end
      
      // Night Mode
      // Activated during low traffic conditions.
      else if(night_req)
        begin
          if(state==S_NS_Green)
            next_state=S_NS_Yellow;
          else if (state==S_EW_Green)
            next_state=S_EW_Yellow;
          else if(state==S_NS_Yellow||state==S_EW_Yellow)
            next_state=S_All_Red;
          else
            next_state=S_Night;

        end
      
      // Normal Adaptive Traffic Flow
      else
        begin
          case(state)
            S_NS_Green:
              begin
                if(timer==0)
                  next_state=S_NS_Yellow;
                else
                  next_state=S_NS_Green;
              end
            S_NS_Yellow:
              begin
                if(timer==0)
                  next_state=S_EW_Green;
                else
                  next_state=S_NS_Yellow;
              end
            S_EW_Green:
              begin
                if(timer==0)
                  next_state=S_EW_Yellow;
                else
                  next_state=S_EW_Green;
              end
            S_EW_Yellow:
              begin
                if(timer==0)
                  next_state=S_NS_Green;
                else
                  next_state=S_EW_Green;
              end
            S_All_Red:
                next_state=S_NS_Green;
            S_Pedestrian:
                next_state=S_All_Red;
            S_Night:
                next_state=S_NS_Green;
            S_Emergency:
                next_state=S_NS_Green;
            S_Fault:
                next_state=S_Fault;
           default:
                next_state=S_NS_Green;
          endcase
        end
    end
  
  // Output Decoder
  always @(*) 
    begin

      // Default OFF
      ns_red = 0;
      ns_yellow = 0;
      ns_green = 0;

      ew_red = 0;
      ew_yellow = 0;
      ew_green = 0;

      case(state)

          S_NS_Green:
          begin
              ns_green = 1;
              ew_red = 1;
          end

          S_NS_Yellow:
          begin
              ns_yellow = 1;
              ew_red = 1;
          end

          S_EW_Green:
          begin
              ns_red = 1;
              ew_green = 1;
          end

          S_EW_Yellow:
          begin
              ns_red = 1;
              ew_yellow = 1;
          end

          S_All_Red:
          begin
              ns_red = 1;
              ew_red = 1;
          end

          S_Pedestrian:
          begin
              ns_red = 1;
              ew_red = 1;
          end

          S_Emergency:
          begin
              ns_red = 1;
              ew_red = 1;
          end

          S_Night:
          begin
              ns_yellow = 1;
              ew_yellow = 1;
          end

          S_Fault:
          begin
              ns_red = 1;
              ew_red = 1;
          end

      endcase

  end
endmodule
