function result=myFreqz2(f,h)
%�����������˲���ת����Ƶ����
%���f�Ĵ�СΪM*N,��Ƶ���˲����Ĵ�СΪ2M*2N
if sum(h(:))~= 0
    h = h/sum(h(:));
end
h = rot90(h,2);      % Unrotate filter since FIR filters are rotated.
center_h = ceil((size(h) + 1)/2); % �˲������ĵ����꣨r,c��
% =========================================================================

[M,N]=size(f);    % �����ߴ�(��/����)�����ݴ�����ͼ��ߴ�ı䣡
P=2*M;
Q=2*N;
% =========================================================================
% Pad h if necessary
% if any(size(h) < [Nr Nc])
%     h(Nr,Nc) = 0.0;
% end
% =========================================================================
hp = zeros(P,Q);
hp(1:size(h,1),1:size(h,2)) = h;
% =========================================================================
% Circularly shift h to put the center element at the upper left corner.
% row_indices = [center_h(1):Nr, 1:(center_h(1)-1)]';
% col_indices = [center_h(2):Nc, 1:(center_h(2)-1)]';
% hp = hp(row_indices, col_indices);
% =========================================================================
%  ֱ�ӵ���MATLAB�е�ѭ����λ��Circularly shift������ circshift��
% =========================================================================
hp = circshift(hp,[-center_h(1)+1,-center_h(2)+1]); 

H = fftshift(fft2(hp));      % Ƶ��ԭ�����Ļ�

% Convert to real if possible
% ʱ��fʵ/ż��������ӦƵ��FΪʵ/ż����
if all(max(abs(imag(H)))<sqrt(eps)) 
    H = real(H);             % ��ȡʵ��
end

% Also check if the response is all imaginary
% ʱ��fʵ/�溯������ӦƵ��F��/�溯��
if all(max(abs(real(H)))<sqrt(eps))
    %H = complex(0,imag(H));  % ʵ������
    H = imag(H);              % ��ȡ�鲿
end

result=H;

end