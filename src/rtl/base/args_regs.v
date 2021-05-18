/********************************************************************************
// @project       Object Detection & Tracking Uint(ODTU)
// @filename      args_regs.v
// @author        3book
// @description   
// @created       2019-11-17T14:44:16.058Z+08:00
// @copyright     Copyright (c) 2019 
// @last-modified 2020-03-31T22:19:26.693Z+08:00
*******************************************************************************/

`timescale 1ns/100ps
module args_regs #(
    parameter BA = 16'h0000	, //Base address
    parameter NU = 2 	, //Registaer Number
    parameter TP = "RO"	, //Registaer type
    parameter DV = "OX"	, //Default value
    parameter AW = 32	, //Address width
    parameter DW = 32  	 //Data width
)(
    input   clk,
    input   rstn,
    // read
    input	[DW*NU-1:0]	rregs,
    input	        	ren,
    input	[AW-1:0]	raddr,
    output	[DW-1:0]	rdata,
    // write
    output	[DW*NU-1:0]	wregs,
    input	        	wen,
    input	[AW-1:0]	waddr,
    input	[DW-1:0]	wdata
);
localparam BS = DW/8;
integer	 i;
generate
if(TP=="RO")begin
    wire	[DW*NU-1:0]	regs;
    assign regs=rregs;
    assign wregs='b0;
    //read
    reg [DW-1:0]  rdata_out;
    always @(*) begin
        for ( i = 0; i < NU; i = i+1 )begin
            if( raddr == BA+i*BS )begin
                rdata_out = regs[i*DW+:DW];
            end
        end
    end
    assign rdata=rdata_out;
end
// write
if(TP=="RW")begin
    reg	[DW*NU-1:0]	regs;
    assign wregs=regs;
    always @(posedge clk) begin
        if ( rstn == 1'b0 )begin
            regs <= DV;
        end else if (wen ==1'b1) begin
            for ( i = 0; i < NU; i = i+1 )begin
                if( waddr == BA+i*BS )begin
                    regs[i*DW+:DW]<= wdata;
                end
            end
        end else;
    end
    //read
    reg [DW-1:0]  rdata_out;
    always @(*) begin
        for ( i = 0; i < NU; i = i+1 )begin
            if( raddr == BA+i*BS )begin
                rdata_out = regs[i*DW+:DW];
            end
        end
    end
    assign rdata=rdata_out;
end
// clear
if(TP=="WC")begin
    reg	[DW*NU-1:0]	regs;
    // assign wregs=regs;
    assign wregs='b0;
    always @(posedge clk) begin
        if ( rstn == 1'b0 )begin
            regs <= 'b0;
        end else if (wen ==1'b1) begin
            for ( i = 0; i < NU; i = i+1 )begin
                if( waddr == BA+i*BS )begin
                    regs[i*DW+:DW]<= regs[i*DW+:DW] & (~wdata);
                end
            end
        end else  begin
            regs <= regs | rregs;
        end
    end
    //read
    reg [DW-1:0]  rdata_out;
    always @(*) begin
        for ( i = 0; i < NU; i = i+1 )begin
            if( raddr == BA+i*BS )begin
                rdata_out = regs[i*DW+:DW];
            end
        end
    end
    assign rdata=rdata_out;
end
endgenerate
endmodule