clc,clear,close all;
orginalPic=imread('cameraman.tif');
noisePic=imnoise(orginalPic,'gaussian',0,0.02);
h=fspecial('gaussian',9,2);
r=4;
[M,N]=size(orginalPic);
imgn=zeros(M+2*r,N+2*r);
imgn(r+1:M+r,r+1:N+r)=noisePic;

imgn(1:r,r+1:N+r)=noisePic(1:r,1:N);                 	%扩展上边界
imgn(1:M+r,N+r+1:N+2*r)=imgn(1:M+r,N+1:N+r);    		%扩展右边界
imgn(M+r+1:M+2*r,r+1:N+2*r)=imgn(M:M+r-1,r+1:N+2*r);    %扩展下边界
imgn(1:M+2*r,1:r)=imgn(1:M+2*r,r+1:2*r);       			%扩展左边界

resultPic=zeros(M,N);
for i=(r+1):(M+r)
    for j=(r+1):(N+r)
        resultPic((i-r),(j-r))=sum(sum(h.*imgn((i-r):(i+r),(j-r):(j+r))));%%相关运算
    end
end
figure(1),
subplot(341),imshow(orginalPic),title('原始图像');
subplot(342),imshow(noisePic),title('噪声图像');
subplot(343),imshow(h,[]),title('空域h平面图');
subplot(344),imshow(mySpectrum(orginalPic)),title('原始图像频谱图');
subplot(345),imshow(mySpectrum(noisePic)),title('噪声图像频谱图');
subplot(347),imshow(uint8(resultPic)),title('空域滤波结果');
subplot(348),imshow(mySpectrum(resultPic)),title('空域滤波后频谱图');
hf=myFreqz2(orginalPic,h);

subplot(346),imshow(hf),title('中心化频域平面图');
resultFFPic=frequencyFilter(noisePic,hf);			%频域滤波
subplot(3,4,10),imshow(resultFFPic),title('频域滤波结果');
subplot(3,4,11),imshow(mySpectrum(resultFFPic)),title('频域滤波结果频谱图');
[z,Fx,Fy]=mesh3D(hf);
figure,mesh(Fx,Fy,z);title('3D频谱图');
