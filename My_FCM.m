function [label_1,para_miu_new,iter,responsivity,X_num]=My_FCM(data,K)
%����K��������
%�����label_1:�۵���, para_miu_new:ģ���������Ħ̣�responsivity:ģ��������
format long
eps=0.001;  %���������ֹ������eps
m=2;  %ģ����Ȩָ����[1,+����)
T=100;  %����������
fitness=zeros(T,1);
[data_num,~]=size(data);
count=zeros(data_num,1);  %ͳ��distant��ÿһ��Ϊ0�ĸ���
responsivity=zeros(data_num,K);
R_up=zeros(data_num,K);
%----------------------------------------------------------------------------------------------------
%��data�����-��С��һ������
X=(data-ones(data_num,1)*min(data))./(ones(data_num,1)*(max(data)-min(data)));
[X_num,X_dim]=size(X);
%----------------------------------------------------------------------------------------------------
%�����ʼ��K����������
rand_array=randperm(X_num);  %����1~X_num֮���������������
para_miu=X(rand_array(1:K),:);  %�������ȡǰK��������X������ȡ��K����Ϊ��ʼ��������
%para_miu1=X(rand_array(1:K),:);
% ----------------------------------------------------------------------------------------------------


% FCM�㷨
for t=1:T
     %�Ľ��ľ��룬���㣨X-para_miu��^2=X^2+para_miu^2-2*para_miu*X'�������СΪX_num*K
      distant=1-exp((sum(X.*X,2))*ones(1,K)+ones(X_num,1)*(sum(para_miu.*para_miu,2))'-2*X*para_miu');
     % distant1=1-exp((sum(X.*X,2))*ones(1,K)+ones(X_num,1)*(sum(para_miu1.*para_miu1,2))'-2*X*para_miu1');
   %ģ������
     sik=exp(-distant.^2/10000)/sum(exp(-distant.^2/10000));
    % sik1=exp(-distant1.^2/10000)/sum(exp(-distant1.^2/10000));
     Gij=sum(30*sik).*(sqrt(distant));
    % Gij1=sum(30*sik1).*(sqrt(distant1));
     %���������Ⱦ���X_num*K
    for i=1:X_num
        count(i)=sum(distant(i,:)==0);
        if count(i)>0
            for k=1:K
                if distant(i,k)==0
                    responsivity(i,k)=1./count(i);
                else
                    responsivity(i,k)=0;
                end
            end
        else
            R_up(i,:)=distant(i,:).^(-1/(m-1));  %�����Ⱦ���ķ��Ӳ���
           responsivity(i,:)= R_up(i,:)./sum( R_up(i,:),2); 
         
        end
    end
   if responsivity<=0.35
        pai=(6/7)*responsivity;
    else
        pai=(6/7)+(-6/7)*responsivity;
    end
    responsivity=responsivity.*(1-pai);
    %Ŀ�꺯��ֵ
    fitness(t)=sum(sum((distant+Gij).*(responsivity.^(m))));
     %���¾�������K*X_dim
    miu_up=(responsivity'.^(m))*X;  %�̵ķ��Ӳ���
    para_miu=miu_up./((sum(responsivity.^(m)))'*ones(1,X_dim));
    if t>1  
        if abs(fitness(t)-fitness(t-1))<eps
            break;
        end
    end
end
para_miu_new=para_miu;
iter=t;  %ʵ�ʵ�������
[~,label_1]=max(responsivity,[],2);
