function [qNew]=calculate_new_q(LC,topology,qData)
%LC is a 3X1 array representing three passive componnets
%qData should be a N-by-4 array where qData(:,1) and qData(:,2) is the
%Inductance and Q, respectively; qdata(:,3) and qData(:,4) is the
%capacitance and Q, respectively. 
%topology is a either 'Pi' or 'T'
%For Pi embedding, positive LC means C 
%For T embedding, positive LC means L
Qcap=50; %fix cap Q
    interMethod='linear';
    switch nargin
        case 3
            qData=[[0,0,0,1e10];qData;[1e10,0,1e10,0]];
        case 2
            qDataL=[0,0;10,22;20,30;30,31;40,30;100,18;190,1e-1;1e10,1e-2]; %Data from EM simulation.
            qData=[qDataL,qDataL(:,1),Qcap*ones(length(qDataL(:,1)),1)];    %fix cap Q=50
        otherwise
            error('The valid number of input arguments is two or three. \n');
    end
    qNew=zeros(1,3);
    for k=1:length(LC)
        if LC(k)>0 && strcmpi(topology,'Pi') || LC(k)<0 && strcmpi(topology,'T')%Cap
            qNew(k)=interp1(qData(:,3),qData(:,4),abs(LC(k)),interMethod);    %vary capacitance
%             qNew(k)=50; %fix cap Q=50
        else %Inductance
            qNew(k)=interp1(qData(:,1),qData(:,2),abs(LC(k)),interMethod); %vary inductance
%             qNew(k)=30;%fix ind Q=30
        end
    end
end