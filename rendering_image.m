function rendering_image(label,K)
%�Էָ���������Ⱦ,4��,label:1��2��3��4
[m, n]=size(label);
read_new=zeros(m,n);
for i=1:m   %��
    for j=1:n    %��
        for k=1:K
            if label(i,j)==k
                read_new(i,j)=floor(255/K)*(k-1);               
            end
        end
    end
end
% ��ת90�㲢��ʾ���� 
figure(3); 
cluster_image=imrotate(read_new, 90); 
imshow(uint8(cluster_image)); 
title('�ָ��');