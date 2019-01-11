function [Imped,Value,Power]=get_embed_pi_vi_independ_q(V1,V2,I1,I2,Q,Freq,Load)
Imped=zeros(5,1);
Value=zeros(4,1);
Power=0;
V1r=real(V1); %V1 V2 I1 I2 are port voltage and cuurent respectively. The notation is consistent with the paper.
V1i=imag(V1);
V2r=real(V2);
V2i=imag(V2);
I1r=real(I1);
I1i=imag(I1);
I2r=real(I2);
I2i=imag(I2);

B=[-I1r;-I1i;-I2r;-I2i];

m=1;

for Q1=[Q(1),-Q(1)]	%emuerate all possible combination of L and C of each embedding component.
    for Q2=[Q(2),-Q(2)]
        for Q3=[Q(3),-Q(3)]
            switch Load		%Depending on the load, on of the three design matrices is used to calculate the embedding.
                case 1
                    A=[V1r,-V1i+V1r/Q1,0,-(V1i-V2i)+(V1r-V2r)/Q3; ...
					V1i,V1r+V1i/Q1,0,(V1r-V2r)+(V1i-V2i)/Q3; ...
					0,0,-V2i+V2r/Q2,-(V2i-V1i)+(V2r-V1r)/Q3; ...
					0,0,V2r+V2i/Q2,(V2r-V1r)+(V2i-V1i)/Q3];
                case 2
                    A=[0 -V1i+V1r/Q1 0 -(V1i-V2i)+(V1r-V2r)/Q3; ...
					0 V1r+V1i/Q1 0 (V1r-V2r)+(V1i-V2i)/Q3; ...
					V2r 0 -V2i+V2r/Q2 -(V2i-V1i)+(V2r-V1r)/Q3; ...
					V2i 0 V2r+V2i/Q2 (V2r-V1r)+(V2i-V1i)/Q3];
                case 3
                    A=[V1r-V2r,-V1i+V1r/Q1,0,-(V1i-V2i)+(V1r-V2r)/Q3; ...
					V1i-V2i,V1r+V1i/Q1,0,(V1r-V2r)+(V1i-V2i)/Q3; ...
					V2r-V1r,0,-V2i+V2r/Q2,-(V2i-V1i)+(V2r-V1r)/Q3; ...
					V2i-V1i,0,V2r+V2i/Q2,(V2r-V1r)+(V2i-V1i)/Q3];
            end
            Imped(1:4)=A\B;
            if (Q1*Imped(2)>0 && Q2*Imped(3)>0 && Q3*Imped(4)>0)	%Filter out embeddings different from preset. Only one solution will exist.
                Imped(5)=m;
                switch Load
                    case 1
                        Power=abs(V1)^2*Imped(1)*500;
                    case 2
                        Power=abs(V2)^2*Imped(1)*500;
                    case 3
                        Power=abs(V1-V2)^2*Imped(1)*500;
                end
                Value(1)=Imped(1);
                for k=2:4
                    if Imped(k)>0
                        Value(k)=Imped(k)/(2*pi*Freq)*1e15;	%Based on the sign of the impedance, calculate the inductance and capacitance.
                    else
                        Value(k)=1/(Imped(k)*2*pi*Freq)*1e12;
                    end
                end
            end
            m=m+1;            
        end
    end
end

end
