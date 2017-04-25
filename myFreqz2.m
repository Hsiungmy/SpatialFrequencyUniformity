function result=myFreqz2(f,h)
%将给定空域滤波器转换到频域中
%如果f的大小为M*N,那频域滤波器的大小为2M*2N
if sum(h(:))~= 0
    h = h/sum(h(:));
end
h = rot90(h,2);      % Unrotate filter since FIR filters are rotated.
center_h = ceil((size(h) + 1)/2); % 滤波器中心点坐标（r,c）
% =========================================================================

[M,N]=size(f);    % 扩充后尺寸(行/列数)，依据待处理图像尺寸改变！
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
%  直接调用MATLAB中的循环移位（Circularly shift）函数 circshift）
% =========================================================================
hp = circshift(hp,[-center_h(1)+1,-center_h(2)+1]); 

H = fftshift(fft2(hp));      % 频率原点中心化

% Convert to real if possible
% 时域f实/偶函数，对应频域F为实/偶函数
if all(max(abs(imag(H)))<sqrt(eps)) 
    H = real(H);             % 仅取实部
end

% Also check if the response is all imaginary
% 时域f实/奇函数，对应频域F虚/奇函数
if all(max(abs(real(H)))<sqrt(eps))
    %H = complex(0,imag(H));  % 实部置零
    H = imag(H);              % 仅取虚部
end

result=H;

end