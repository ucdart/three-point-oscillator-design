function [Imped,Value,Power]=get_embed_vi_vari_q(V1,V2,I1,I2,Freq,EMBED,Load)
%difference with get_Embed_Z_VI_old is this code returns the embedding with
%maximum output power if two embeddings exist(may be it doesn't exist at
%all)
    ERROR=0.001;
%     EMBED='T';
    qLast=[30,30,30];
    ImpedLast=zeros(4,1);
    ALPHA=0.2;
    iter=0;
    while(1)
        iter=iter+1;
        if strcmpi(EMBED,'T')
            [Imped,Value,Power]=get_embed_z_vi_independ_q(V1,V2,I1,I2,qLast,Freq,Load);
        elseif strcmpi(EMBED,'Pi')
            [Imped,Value,Power]=get_embed_pi_vi_independ_q(V1,V2,I1,I2,qLast,Freq,Load);
        end
            qNew=calculate_new_q(Value(2:4),EMBED)*ALPHA+qLast*(1-ALPHA);
            error=norm(Imped(1:4)-ImpedLast(1:4))/sum(abs(Imped(1:4)));
            if error<ERROR
                return
            else
                qLast=qNew;
                ImpedLast=Imped;
            end  
            
    end
end