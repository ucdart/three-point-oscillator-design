%Plot Padd vs Vs1 A 
function [VS1max,VL1max,PL1max,valueMax,powerMax]=osc_embed_sweep(Freq,Load,Embed,Data)
VS1=Data(:,3);
VL1=Data(:,2);
PL1=Data(:,1);
Vg=Data(:,4)+Data(:,5)*1i;
Vd=Data(:,6)+Data(:,7)*1i;
Ig=Data(:,8)+Data(:,9)*1i;
Id=Data(:,10)+Data(:,11)*1i;
PowerPlot=zeros(length(Data(:,1)),1);
ImpedData=zeros(length(Data(:,1)),5);
ValueData=zeros(length(Data(:,1)),4);
loop=0;
fprintf('Start searching...\n');
for k=1:length(Data(:,1))
    loop=loop+1;
    if mod(loop,1000)==0
        fprintf('Iteration=%d\n',loop);
    end
    %Value dependent Q
    [Imped,Value,Power]=get_embed_vi_vari_q(Vg(k),Vd(k),Ig(k),Id(k),Freq,Embed,Load);
    PowerPlot(k)=Power;
    ImpedData(k,:)=Imped;
    ValueData(k,:)=Value;
end
[powerMax,powerIndex]=max(PowerPlot);
VS1max=VS1(powerIndex);
VL1max=VL1(powerIndex);
PL1max=PL1(powerIndex);
valueMax=ValueData(powerIndex,:);