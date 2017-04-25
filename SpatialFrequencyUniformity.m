clc,clear,close all;
orginalPic=imread('cameraman.tif');
noisePic=imnoise(orginalPic,'gaussian',0,0.02);
h=fspecial('gaussian',9,2);
r=4;
[M,N]=size(orginalPic);
imgn=zeros(M+2*r,N+2*r);
imgn(r+1:M+r,r+1:N+r)=noisePic;

imgn(1:r,r+1:N+r)=noisePic(1:r,1:N);                 	%��չ�ϱ߽�
imgn(1:M+r,N+r+1:N+2*r)=imgn(1:M+r,N+1:N+r);    		%��չ�ұ߽�
imgn(M+r+1:M+2*r,r+1:N+2*r)=imgn(M:M+r-1,r+1:N+2*r);    %��չ�±߽�
imgn(1:M+2*r,1:r)=imgn(1:M+2*r,r+1:2*r);       			%��չ��߽�

resultPic=zeros(M,N);
for i=(r+1):(M+r)
    for j=(r+1):(N+r)
        resultPic((i-r),(j-r))=sum(sum(h.*imgn((i-r):(i+r),(j-r):(j+r))));%%�������
    end
end
figure(1),
subplot(341),imshow(orginalPic),title('ԭʼͼ��');
subplot(342),imshow(noisePic),title('����ͼ��');
subplot(343),imshow(h,[]),title('����hƽ��ͼ');
subplot(344),imshow(mySpectrum(orginalPic)),title('ԭʼͼ��Ƶ��ͼ');
subplot(345),imshow(mySpectrum(noisePic)),title('����ͼ��Ƶ��ͼ');
subplot(347),imshow(uint8(resultPic)),title('�����˲����');
subplot(348),imshow(mySpectrum(resultPic)),title('�����˲���Ƶ��ͼ');
hf=myFreqz2(orginalPic,h);

subplot(346),imshow(hf),title('���Ļ�Ƶ��ƽ��ͼ');
resultFFPic=frequencyFilter(noisePic,hf);			%Ƶ���˲�
subplot(3,4,10),imshow(resultFFPic),title('Ƶ���˲����');
subplot(3,4,11),imshow(mySpectrum(resultFFPic)),title('Ƶ���˲����Ƶ��ͼ');
[z,Fx,Fy]=mesh3D(hf);
figure,mesh(Fx,Fy,z);title('3DƵ��ͼ');
