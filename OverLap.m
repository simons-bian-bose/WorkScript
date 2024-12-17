% ��������
x = randn(1, 10000);       % �����ź�
h = fir1(63, 0.25);        % FIR �˲���
L = length(h);             % �˲�������
N = 512;                   % ��Ч���ݳ���

% ��ʼ��
M = N + L - 1;             % �ֶγ���
H = fft(h, M);             % �˲����� FFT
numSegments = ceil(length(x) / N);
y = zeros(1, length(x));    % ����ź�
x_padded = [x, zeros(1, M)]; 

% Overlap-Save ʵ��
for k = 1:numSegments
    startIdx = (k-1)*N + 1;
    endIdx = startIdx + M - 1;
    x_segment = x_padded(startIdx:endIdx);

    % FFT -> Ƶ����� -> IFFT
    X_segment = fft(x_segment, M);
    Y_segment = X_segment .* H;
    y_ifft = ifft(Y_segment, M);

    % ����ǰ L-1 ������
    y_valid = y_ifft(L:end);

    % ƴ�ӽ��
    y(startIdx:startIdx+N-1) = y_valid;
end

% ��ʱ�����Ա�
y_conv = conv(x, h, 'same');
y = y(1:length(y_conv)); % ��ȡ�����ƥ�䳤��

% �����
error = norm(y - y_conv) / norm(y_conv);
disp(['������: ', num2str(error)]);

% ��ͼ
figure;
plot(y_conv, 'b--'); hold on;
plot(y, 'r');
legend('ʱ����', 'FFT Overlap-Save');
title('�˲�����Ա�');

plot([y(1:1000)',y_conv(32:1031)'])
