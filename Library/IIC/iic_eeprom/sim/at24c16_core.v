 //`define timeslice 100
`timescale 1 ns / 1 ns
module at24c16_core(scl,sda,wp,a0,a1,a2);
// begin spec parameter
// pin size parameter
parameter 	wordbitnum= 8,	// number of bit for word
		wordnum=2048,	// number of words
		Tsusta=300,
		timeslice=100;
// io ports
parameter EPP_BASE_PORT = 11'h0ff;
parameter CLOCK_nWAIT_PORT = 11'h0fb;
input		scl,wp, a0,a1,a2;
inout		sda;

reg out_en;
reg start,stop;
reg sda_out,again_out,again_start;
reg[7:0]out_temp;
reg[10:0]addr;
reg[2:0]state;

reg[7:0]device_addr1,word_addr,device_addr2,write_data;
reg[7:0] init_val;

// eeprom
reg	[wordbitnum-1 : 0]	e2prom[0 : wordnum-1];
reg	[7 : 0]	write_data_temp[0 : 15];

buf (sda_in, sda);
bufif1(sda, sda_out, out_en);

integer k,i;

// init eeprom
initial 
begin
	init_val = 8'hff;
	for (k=0;k<wordnum;k=k+1)
//		e2prom[k] = init_val+k ;
		e2prom[k] = k;
		
e2prom[EPP_BASE_PORT] = 8'hfe;
e2prom[CLOCK_nWAIT_PORT] = 8'h00;
	state=3'b000;
end

always @ (state)
begin
	if (state==3'b000)			//000 reset
	 	begin 
	 		addr=11'b00000000000;
			out_en=1'b0;
			start = 1'b0;
			stop = 1'b0;
			again_out=1'b0;
			again_start=1'b0;
	 		
	 	end	

end


always @ (start or stop)
begin
	if ((start==1'b1)&&(stop!=1'b1))			//000 reset
	 	begin 
	 		state=3'b001;
	 		shift_in(device_addr1);
	 		shift_in(word_addr);
	 		addr={device_addr1[3:1],word_addr[7:0]};
	 		
	 	end	

end
always @ (again_start or stop)
begin
	if ((again_start==1'b1)&&(stop!=1'b1))			//000 reset
		begin 
 			state=3'b010;
			shift_in_addr2(device_addr2);
			if((device_addr1[7:4]==4'b1010)&&(device_addr2[7:4]==4'b1010))
				out_temp[7:0]=e2prom[addr];
			state=3'b011;
			shift_out;
		end				
end	

always @ (again_out or stop)
begin
	if ((again_out==1'b1)&&(state==3'b011)&&(stop!=1'b1))			//000 reset
		begin 
 			while(again_out==1'b1)
 				shift_out;
 			//shift_out;
		end
end	

// Clock Rise & Fall Time
real	tSCLrise, tSDAfall,tSDArise,tSCLfall;

always @ (posedge scl) begin
	tSCLrise = $realtime;
end

//start
always @ (negedge sda_in) begin
	tSDAfall = $realtime;
	if (scl == 1'b1)  
		begin
			if (tSDAfall - tSCLrise > Tsusta)
				 begin	
					stop = 1'b0;
					start= 1'b1;
				end
		end
	//else	start = 1'b0;
end

always @ (negedge sda) begin
	tSDAfall = $realtime;
	if (scl == 1'b1)  
		begin
			if ((tSDAfall - tSCLrise > Tsusta)&&(state!=3'b000)&&(state!=3'b011))
			 begin	
					again_start= 1'b1;
				end
		end
	//else	start = 1'b0;
end

//stop
always @ (posedge sda) begin
	tSDArise = $realtime;
	if (scl == 1'b1)  
		begin
			if ((tSDArise - tSCLrise > 100)&&(tSDAfall - tSCLrise< Tsusta) )
				begin	
					stop = 1'b1;
					start= 1'b0;
					again_start= 1'b0;
					again_out=1'b0;
				end
		end
	//else	stop = 1'b0;
end

task shift_in;
output[7:0] shift;
begin
	@ (posedge scl)	shift[7]=sda_in;
	@ (posedge scl)	shift[6]=sda_in;
	@ (posedge scl)	shift[5]=sda_in;
	@ (posedge scl)	shift[4]=sda_in;
	@ (posedge scl)	shift[3]=sda_in;
	@ (posedge scl)	shift[2]=sda_in;
	@ (posedge scl)	shift[1]=sda_in;
	@ (posedge scl)	shift[0]=sda_in;
	
	@ (negedge scl)	
	#timeslice out_en=1'b1;
		sda_out=1'b0;
	
	//if(state!=3'b010)
	begin
		@ (negedge scl)	#timeslice out_en=1'b0;
	end
end
endtask

task shift_in_addr2;
output[7:0] shift;
begin
	@ (posedge scl)	shift[7]=sda_in;
	@ (posedge scl)	shift[6]=sda_in;
	@ (posedge scl)	shift[5]=sda_in;
	@ (posedge scl)	shift[4]=sda_in;
	@ (posedge scl)	shift[3]=sda_in;
	@ (posedge scl)	shift[2]=sda_in;
	@ (posedge scl)	shift[1]=sda_in;
	@ (posedge scl)	shift[0]=sda_in;
	
	@ (negedge scl)	
	#timeslice out_en=1'b1;
		sda_out=1'b0;
	//@ (negedge scl)	;
end
endtask

task shift_out;
begin
	@ (negedge scl)	begin out_en=1'b1; sda_out=out_temp[7]; end
	//again_out=1'b0;	
	@ (negedge scl)	sda_out=out_temp[6];
	@ (negedge scl)	sda_out=out_temp[5];
	@ (negedge scl)	sda_out=out_temp[4];
	@ (negedge scl)	sda_out=out_temp[3];
	@ (negedge scl)	sda_out=out_temp[2];
	@ (negedge scl)	sda_out=out_temp[1];
	@ (negedge scl)	sda_out=out_temp[0];
	@ (negedge scl)
	out_en=1'b0;
	@ (posedge scl) 
	begin
		if(sda_in==1'b1) again_out=1'b0;
		else  
			begin
	//@ (negedge scl);
	#1;				 again_out=1'b1;
				 addr=addr+1;
	 			 out_temp[7:0]=e2prom[addr];
//	 			 out_en=1'b1;
	 		end
		end

end
endtask

endmodule