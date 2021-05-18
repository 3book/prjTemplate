`timescale  1ns / 10ps
module tb_top;
// obj_fc Parameters
parameter PERIOD  = 10      ;
parameter DW      = 1       ;
parameter CW      = 4       ;
parameter IC      = 48      ;
parameter IR      = 32      ;
parameter TC      = 64      ;
parameter TR      = 40      ;
// parameter IC      = 1920    ;
// parameter IR      = 1080    ;
// parameter TC      = 2200    ;
// parameter TR      = 1125    ;
parameter REG_DW  = 32          ;
parameter ICW  = 11   ;
parameter IRW  = 11   ;
// parameter ICW  = $clog2(IC-1)   ;
// parameter IRW  = $clog2(IR-1)   ;
parameter MW      = 209         ;
parameter CCW     = 4*(ICW+IRW) ;
parameter IFW     = 2*ICW+MW+CCW;

// obj_fc Inputs
reg   clk                                  = 0 ;
reg   rst                                  = 0 ;
reg   rstn                                 = 0 ;
reg   [MW-1:0]  s_moments_tdata            = 0 ;
reg   s_moments_tvalid                     = 0 ;
reg   [ 4-1:0]  s_moments_tuser            = 0 ;
reg   s_moments_tlast                      = 0 ;
reg   [CCW-1:0]  s_points_tdata            = 0 ;
reg   s_points_tvalid                      = 0 ;
reg   [ 4-1:0]  s_points_tuser             = 0 ;
reg   s_points_tlast                       = 0 ;
reg   m_side_tready                        = 0 ;
reg   m_shift_tready                       = 0 ;
reg   m_angle_tready                       = 0 ;
reg   [REG_DW-1:0]  reg_cfg                = 0 ;

// obj_fc Outputs
wire  s_moments_tready                     ;
wire  s_points_tready                      ;
wire  [16-1:0]  m_side_tdata               ;
wire  m_side_tvalid                        ;
wire  [ 4-1:0]  m_side_tuser               ;
wire  m_side_tlast                         ;
wire  [16-1:0]  m_shift_tdata              ;
wire  m_shift_tvalid                       ;
wire  [ 4-1:0]  m_shift_tuser              ;
wire  m_shift_tlast                        ;
wire  [16-1:0]  m_angle_tdata              ;
wire  m_angle_tvalid                       ;
wire  [ 4-1:0]  m_angle_tuser              ;
wire  m_angle_tlast                        ;
wire  [REG_DW*4-1:0]  reg_cnt              ;
wire  [REG_DW-1:0]  reg_sta                ;
wire  [REG_DW-1:0]  reg_err                ;
initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

// initial
// begin
//     string fileData;
//     bit [31:0] tdata [$];
//     // string fgFilePath="./fg.yuv";
//     automatic string bgFilePath="./bg.yuv";
//     // int fgFileId=$fopen(fgFilePath,"rb");
//     automatic int bgFileId=$fopen(bgFilePath,"r");
//     $fgets(fileData,bgFileId);
//     tdata={>>32{fileData}};
//     $display("[0-3]a=%h", tdata[2]);
// end
initial
begin
    #(PERIOD*10) rst  =  1;
    #(PERIOD*20) rst  =  0;
    repeat(8) @(posedge clk);
    fork
        gen_data;
        monitor;
    join
end
obj_fc #(
    .IC     ( IC     ),
    .IR     ( IR     ),
    .REG_DW ( REG_DW ),
    .ICW    ( ICW    ),
    .IRW    ( IRW    ),
    .MW     ( MW     ),
    .CCW    ( CCW    ),
    .IFW    ( IFW    ))
 DUT (
    .clk                     ( clk                              ),
    .rst                     ( rst                              ),
    .rstn                    ( ~rst                             ),
    .s_moments_tdata         ( s_moments_tdata   [MW-1:0]       ),
    .s_moments_tvalid        ( s_moments_tvalid                 ),
    .s_moments_tuser         ( s_moments_tuser   [ 4-1:0]       ),
    .s_moments_tlast         ( s_moments_tlast                  ),
    .s_points_tdata          ( s_points_tdata    [CCW-1:0]      ),
    .s_points_tvalid         ( s_points_tvalid                  ),
    .s_points_tuser          ( s_points_tuser    [ 4-1:0]       ),
    .s_points_tlast          ( s_points_tlast                   ),
    .m_side_tready           ( m_side_tready                    ),
    .m_shift_tready          ( m_shift_tready                   ),
    .m_angle_tready          ( m_angle_tready                   ),
    .reg_cfg                 ( reg_cfg           [REG_DW-1:0]   ),

    .s_moments_tready        ( s_moments_tready                 ),
    .s_points_tready         ( s_points_tready                  ),
    .m_side_tdata            ( m_side_tdata      [16-1:0]       ),
    .m_side_tvalid           ( m_side_tvalid                    ),
    .m_side_tuser            ( m_side_tuser      [ 4-1:0]       ),
    .m_side_tlast            ( m_side_tlast                     ),
    .m_shift_tdata           ( m_shift_tdata     [16-1:0]       ),
    .m_shift_tvalid          ( m_shift_tvalid                   ),
    .m_shift_tuser           ( m_shift_tuser     [ 4-1:0]       ),
    .m_shift_tlast           ( m_shift_tlast                    ),
    .m_angle_tdata           ( m_angle_tdata     [16-1:0]       ),
    .m_angle_tvalid          ( m_angle_tvalid                   ),
    .m_angle_tuser           ( m_angle_tuser     [ 4-1:0]       ),
    .m_angle_tlast           ( m_angle_tlast                    ),
    .reg_cnt                 ( reg_cnt           [REG_DW*4-1:0] ),
    .reg_sta                 ( reg_sta           [REG_DW-1:0]   ),
    .reg_err                 ( reg_err           [REG_DW-1:0]   )
);

parameter threshold = 10'h100;
// parameter kernel = 16'b000_0001_0101_1011;
initial
begin
    reg_cfg = threshold;
    repeat(IR*IC*2) @(posedge clk);
    $finish;
end
int cnt =0 ;
int x,y,z;
bit sof,eof,sol,eol;
// 19*10 22*11
// generate data

task gen_data;
    forever begin
        z=cnt%(TC*TR);
        y=z/(TC);
        x=z%(TC);
        sol=(x==0)? 1:0;
        eol=(x==IC-1)? 1:0;
        sof=(y==0)? sol:0;
        eof=(y==IR-1)? eol:0;
        @(posedge clk);
        if(x<IC && y<IR)begin
            // s_moments_tlast <= eol;
            // s_moments_tuser <= {sof,eof,sol,eol};
            // s_points_tlast <= eol;
            // s_points_tuser <= {sof,eof,sol,eol};
            // if(x==5 )begin          
            if(x==5 && y==5)begin          
                s_moments_tlast <= 1'b0;
                s_moments_tuser <= 2'b10;
                s_moments_tdata <= 209'h1122_3344_5566_7788_99aa_bbcc_ddee_ff00_1234_5678_9abc_def0_1111;
                s_moments_tvalid <=1'b1;

                s_points_tlast <= 1'b0;
                s_points_tuser <= 2'b10;
                s_points_tvalid <=1'b1;
                s_points_tdata <='h12_3456_7811_2233_4455_6677;
            end else if(x==7 && y==10)begin
                s_moments_tlast <= 1'b1;
                s_moments_tuser <= 2'b01;          
                s_moments_tvalid <=1'b1;
                s_moments_tdata <= 209'hff00_1234_5678_9abc_def0_1111_1122_3344_5566_7788_99aa_bbcc_ddee;

                s_points_tlast <= 1'b1;
                s_points_tuser <= 2'b01;
                s_points_tvalid <=1'b1;
                s_points_tdata <='h56_7811_2233_4455_6677_1234;
            end else begin
                s_moments_tvalid <=1'b0;
                s_points_tvalid <=1'b0;
            end
        end else begin
            s_moments_tdata <= 'b0;
            s_moments_tlast <= 1'b0;
            s_moments_tuser <= 'b0;
            s_moments_tvalid <=1'b0;
        end
        // wait(s_moments_tready==1'b1);
        cnt=cnt+1;
    end
endtask
task monitor;
int item_q[$]; 
int a,b,c;
real rad,deg,grad;
    m_side_tready=1'b1;
    m_shift_tready=1'b1;
    m_angle_tready=1'b1;
    forever begin
        @(posedge clk)
        if(m_side_tvalid==1)begin
            item_q.push_back(m_side_tdata);
            if(item_q.size==3)begin
                {>>32{a,b,c}}=item_q;
                $display("side a=%d",a);
                $display("side b=%d",b);
                $display("side c=%d",c);
                item_q={};
            end
        end
        if(m_angle_tvalid==1)begin
        // 2QN
            rad=$signed(m_angle_tdata)*1.0/(2**13);
            deg=rad*180/3.1415926;
            grad=rad*400/3.1415926;
            $display("angle RAD=%f, DEG=%f,GRAD= ",rad,deg,grad);
        end            
        if(m_shift_tvalid==1)begin
            $display("shift =%d",m_shift_tdata);
        end            
    end
endtask
endmodule