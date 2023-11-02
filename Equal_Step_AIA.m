function [Phi] = Equal_Step_AIA(I,theta,mask)

for i=1:1:size(I,3)
eval("I"+i+"=I(:,:,"+i+");");    
eval("I"+i+"(mask==0)=nan;");
eval("I"+i+"=reshape(I"+i+",size(I,1),size(I,2));")
eval("fai("+i+")=theta*("+i+"-1);");
eval("I(:,:,+"+i+")=I"+i+";");
end
jsq=0;
%%
while(1)
%%AIA迭代
    %构建帧间矩阵
    Z11=size(I,3);
    Z12=sum(cos(fai));
    Z13=sum(sin(fai));
    Z21=Z12;
    Z22=sum(cos(fai).^2);
    Z23=sum(sin(fai).*cos(fai));
    Z31=Z13;
    Z32=Z23;
    Z33=sum(sin(fai).^2);
    Z=[Z11 Z12 Z13;Z21 Z22 Z23;Z31 Z32 Z33;];
    %构造数据矩阵
    Iz_11=0;
    Iz_21=0;
    Iz_31=0;
    for i=1:1:size(I,3)
        Iz_11=Iz_11+I(:,:,i);
        Iz_21=Iz_21+I(:,:,i)*cos(fai(i));
        Iz_31=Iz_31+I(:,:,i)*sin(fai(i));
    end
    Iz_11=reshape(Iz_11,1,size(Iz_11,1)*size(Iz_11,2));
    Iz_21=reshape(Iz_21,1,size(Iz_21,1)*size(Iz_21,2));
    Iz_31=reshape(Iz_31,1,size(Iz_31,1)*size(Iz_31,2));
    Iz=[Iz_11;Iz_21;Iz_31];
    %计算
    C=Z\Iz;
    Phi=atan2(-C(3,:),C(2,:));
    Phi=reshape(Phi,size(I(:,:,1),1),size(I(:,:,1),2));
    Phi(mask==0)=nan;
%     figure,mesh(Equal_step_tz(I,pi/2));
    %%构造帧内矩阵
    Phi2=Phi;
    Phi2(isnan(Phi2))=[];
    
    F11=size(Phi2,1)*size(Phi2,2);
    F12=sum(sum(cos(Phi2)));
    F13=sum(sum(sin(Phi2)));
    F21=F12;
    F22=sum(sum(cos(Phi2).^2));
    F23=sum(sum(cos(Phi2).*sin(Phi2)));
    F31=F13;
    F32=F23;
    F33=sum(sum(sin(Phi2).^2));
    F=[F11 F12 F13;F21 F22 F23;F31 F32 F33];
    %%构造数据矩阵
    It_11=[]; It_21=[];It_31=[];
    for i=1:1:size(I,3)
        I2=I(:,:,i);
        I2(isnan(I2))=[];
        It_11=[It_11 sum(sum(I2))];
        It_21=[It_21 sum(sum(I2.*cos(Phi2)))];
        It_31=[It_31 sum(sum(I2.*sin(Phi2)))];
    end
    It=[It_11;It_21;It_31];
    S=F\It;
    Theta=atan2(S(3,:),-S(2,:));
    Theta=unwrap(Theta);
     if((abs((max(Theta)-min(Theta))-(max(fai)-min(fai)))<0.00001))
        break;
     end
     fai=Theta;
     jsq=jsq+1;
end
% end
end

