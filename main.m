function [read_new, mark]=main(filename, num)
%����ʵ��ͼ���е�0��1��2��3�ó�������������Ϊ0.
%����main(filename, num)�еĵ�һ������filename������ȡ��rawb�ļ����ļ������ڶ�������num���ǵڶ����š�
%���磺main('t1_icbm_normal_1mm_pn0_rf0.rawb',100)
mark=Mark('phantom_1.0mm_normal_crisp.rawb',num);
read=readrawb(filename, num);
[row, col]=size(read);
read_new=zeros(row, col);
for i=1:row   %��
    for j=1:col    %��
        if mark(i,j)==0
            read_new(i,j)=0;
        else
            read_new(i,j)=read(i,j);   %����0��1��2��3���ó�����������Ϊ0
        end
    end
end
%��ת90�㲢��ʾ����
figure(1);  
init_image=imrotate(read_new, 90); 
imshow(uint8(init_image)); 
title('ԭͼ��');