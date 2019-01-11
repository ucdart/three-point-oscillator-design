function [Imped,Value,Power]=get_embed_z_vi_independ_q(V1,V2,I1,I2,Q,Freq,Load)
%difference with get_Embed_Z_VI_old is this code returns the embedding with
%maximum output power if two embeddings exist(may be it doesn't exist at
%all)
Imped=zeros(5,1);
Value=zeros(4,1);
Power=0;
V1r=real(V1);   %V1 V2 I1 I2 are port voltage and cuurent respectively. The notation is consistent with the paper.
V1i=imag(V1);
V2r=real(V2);
V2i=imag(V2);
I1r=real(I1);
I1i=imag(I1);
I2r=real(I2);
I2i=imag(I2);

B=[-V1r;-V1i;-V2r;-V2i];

m=1;
impedTmp=zeros(5,1);
powerTmp=0;
for Q1=[-Q(1),Q(1)] %emuerate all possible combination of L and C of each embedding component.
    for Q2=[-Q(2),Q(2)]
        for Q3=[-Q(3),Q(3)]
            switch Load     %Depending on the load, on of the three design matrices is used to calculate the embedding.
                case 1
                    A=[I1r -I1i+I1r/Q1 0 (I1r+I2r)/Q3-(I1i+I2i); ...
                        I1i I1r+I1i/Q1 0 (I1r+I2r)+(I1i+I2i)/Q3; ...
                        0 0 -I2i+I2r/Q2 (I1r+I2r)/Q3-(I1i+I2i); ...
                        0 0 I2r+I2i/Q2 (I2r+I1r)+(I2i+I1i)/Q3];
                case 2
                    A=[0,-I1i+I1r/Q1,0,(I1r+I2r)/Q3-(I1i+I2i); ...
                        0,I1r+I1i/Q1,0,(I1r+I2r)+(I1i+I2i)/Q3; ...
                        I2r,0,-I2i+I2r/Q2,(I1r+I2r)/Q3-(I1i+I2i); ...
                        I2i,0,I2r+I2i/Q2,(I2r+I1r)+(I2i+I1i)/Q3];
                case 3
                    A=[I1r+I2r -I1i+I1r/Q1 0 (I1r+I2r)/Q3-(I1i+I2i); ...
						I1i+I2i I1r+I1i/Q1 0 (I1r+I2r)+(I1i+I2i)/Q3; ...
						I1r+I2r 0 -I2i+I2r/Q2 (I1r+I2r)/Q3-(I1i+I2i); ...
						I1i+I2i 0 I2r+I2i/Q2 (I2r+I1r)+(I2i+I1i)/Q3];
            end
            Imped(1:4)=A\B;
            if (Q1*Imped(2)>0 && Q2*Imped(3)>0 && Q3*Imped(4)>0)    %Filter out embeddings different from preset. Only one solution will exist.
                Imped(5)=m;
                switch Load
                    case 1
                        Power=abs(I1)^2*Imped(1)*500;
                    case 2
                        Power=abs(I2)^2*Imped(1)*500;
                    case 3
                        Power=abs(I1+I2)^2*Imped(1)*500;
                end
                if Power>powerTmp
                    powerTmp=Power;
                    impedTmp=Imped;
                end
            end
            m=m+1;            
        end
    end
end
Value(1)=impedTmp(1);
for k=2:4
    if impedTmp(k)>0    %Based on the sign of the impedance, calculate the inductance and capacitance.
        Value(k)=impedTmp(k)/(2*pi*Freq)*1e12;
    else
        Value(k)=1/(impedTmp(k)*2*pi*Freq)*1e15;
    end
end
Power=powerTmp;
Imped=impedTmp;
end
