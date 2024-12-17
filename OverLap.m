% 参数设置
x = randn(1, 10000);       % 输入信号
h = fir1(63, 0.25);        % FIR 滤波器
L = length(h);             % 滤波器长度
N = 512;                   % 有效数据长度

% 初始化
M = N + L - 1;             % 分段长度
H = fft(h, M);             % 滤波器的 FFT
numSegments = ceil(length(x) / N);
y = zeros(1, length(x));    % 输出信号
x_padded = [x, zeros(1, M)]; 

% Overlap-Save 实现
for k = 1:numSegments
    startIdx = (k-1)*N + 1;
    endIdx = startIdx + M - 1;
    x_segment = x_padded(startIdx:endIdx);

    % FFT -> 频域相乘 -> IFFT
    X_segment = fft(x_segment, M);
    Y_segment = X_segment .* H;
    y_ifft = ifft(Y_segment, M);

    % 丢弃前 L-1 个样本
    y_valid = y_ifft(L:end);

    % 拼接结果
    y(startIdx:startIdx+N-1) = y_valid;
end

% 与时域卷积对比
y_conv = conv(x, h, 'same');
y = y(1:length(y_conv)); % 截取结果以匹配长度

% 误差检查
error = norm(y - y_conv) / norm(y_conv);
disp(['相对误差: ', num2str(error)]);

% 绘图
figure;
plot(y_conv, 'b--'); hold on;
plot(y, 'r');
legend('时域卷积', 'FFT Overlap-Save');
title('滤波结果对比');

plot([y(1:1000)',y_conv(32:1031)'])
