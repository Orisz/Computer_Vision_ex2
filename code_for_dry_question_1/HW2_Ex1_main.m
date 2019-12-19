% Question 1
 
% part 1c.
 
% Original image:
Image = [4 1 6 1 3;...
         3 2 7 7 2;...
         2 5 7 3 7;...
         1 4 7 1 3;
         0 1 6 4 4];

% Our chosen filter:     
Filter = [1 0 1;...
          0 1 0;...
          1 0 1];
      
% Normalize filter:
Filter = Filter./sum(abs(Filter(:)));
 
% Our choise of Stride and Zero-padding:
stride = 3;
NumZeroPadding = 3;
 
ImageSize = size(Image);
ImageForConv = zeros(ImageSize+[2*NumZeroPadding,2*NumZeroPadding]);

% Zero-pad the original image:
ImageForConv((NumZeroPadding+1):(ImageSize(1)+NumZeroPadding),(NumZeroPadding+1):(ImageSize(2)+NumZeroPadding)) = Image;

% Convolve the zero-padded image with the chosen filter
C = conv2(ImageForConv,Filter,'valid');

% Take only the relevant results according to the chosen stride:
Result = C(1:stride:end,1:stride:end);
      
 
% Question 3

% Simulate Accuracy vs. iteration graphs:

% Example of underfitting:
NumIter = 0:20:1000;
TrainAccur = 0.0001.*NumIter + 0.2 + 0.003*randn(size(NumIter));
TestAccur =  0.0001.*NumIter + 0.18 + 0.003*randn(size(NumIter));
figure;
plot(NumIter,TrainAccur,'b');
hold on;
plot(NumIter,TestAccur,'r');
xlabel('# Iterations (epochs)');
ylabel('Accuracy');
title('Accuracy vs. Numer of iterations, Underfitting')
legend('Train','Test','location','northwest');
 
% Example of wanted behavior:
NumIter = 0:20:1000;
TrainAccur = 0.2+0.15*log(1+0.06.*NumIter )+ 0.003*randn(size(NumIter));
TestAccur =  0.18+0.15*log(1+0.06.*NumIter )+ 0.003*randn(size(NumIter));
figure;
plot(NumIter,TrainAccur,'b');
hold on;
plot(NumIter,TestAccur,'r');
xlabel('# Iterations (epochs)');
ylabel('Accuracy');
title('Accuracy vs. Numer of iterations, Wanted')
legend('Train','Test','location','northwest');
 
% Example of overfitting:
NumIter = 0:20:1000;
TrainAccur = 0.2+0.15*log(1+0.06.*NumIter )+ 0.003*randn(size(NumIter));
TestAccur =  0.18+0.06*log(1+0.6.*NumIter )+ 0.003*randn(size(NumIter))-0.0000002*NumIter.^2;
figure;
plot(NumIter,TrainAccur,'b');
hold on;
plot(NumIter,TestAccur,'r');
xlabel('# Iterations (epochs)');
ylabel('Accuracy');
title('Accuracy vs. Numer of iterations, Overfitting')
legend('Train','Test','location','northwest');



