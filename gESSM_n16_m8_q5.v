module gESSM_n16_m8_q5(a, b, ris);

// **** Unsigned multiplier with recursive SSM approximate ****
input wire [15:0] a;
input wire [15:0] b;
output reg [31:0] ris;

wire alfa_a1,alfa_a2, alfa_b1, alfa_b2;
wire [7:0] assm, bssm, assm_tmp, bssm_tmp;

// **********************
// **** SEGMENTATION ****

assign alfa_a1 = (a[15] || a[14] || a[13]);
assign alfa_a2 = (a[12] || a[11] || a[10] || a[9] || a[8]);

assign assm_tmp = (alfa_a2==1'b0)? a[7:0] : a[12:5];
assign assm = (alfa_a1==1'b0)? assm_tmp : a[15:8];

assign alfa_b1 = (b[15] || b[14] || b[13]);
assign alfa_b2 = (b[12] || b[11] || b[10] || b[9] || b[8]);

assign bssm_tmp = (alfa_b2==1'b0)? b[7:0] : b[12:5];
assign bssm = (alfa_b1==1'b0)? bssm_tmp : b[15:8];

// **** PRODUCT ****

wire [15:0] Mssm;
assign Mssm = assm* /* cadence sub_arch non_booth */ bssm;

// **** OUTPUT SHIFT ****

reg [23:0] ris_tmp1;
always@* begin
    case({alfa_a1, alfa_a2})
        2'b00 :ris_tmp1<=Mssm;
        2'b01 :ris_tmp1<={Mssm,5'd0};
        default:ris_tmp1<={Mssm,8'd0};
    endcase
end

always@* begin
    case({alfa_b1, alfa_b2})
        2'b00 :ris<=ris_tmp1;
        2'b01 :ris<={ris_tmp1,5'd0};
        default:ris<={ris_tmp1,8'd0};
    endcase
end

endmodule
