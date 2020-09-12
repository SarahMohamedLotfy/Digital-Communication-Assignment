%%%   Second Case  %%%
clc;
clear;
numberOfBits=10000;  % Number of input bits
inputBits=randi([0,1],1,numberOfBits); %Input Bit Stream


%Generate g which is pulse shaping represents input bitstream
len=numberOfBits;
n=200;
N=n*len;
dt=len/N;
t1=0:dt:len;
g=zeros(1,length(t1));
for i=0:len-1;
    if inputBits(i+1)==1
        g(i*n+1 : (i+1)*n)=1;
    else
        g(i*n+1 : (i+1)*n)=-1;
    end;
end;

%Addingg noise at x =20
E = 1;
x = 20;
No=(E ./(10.^(x/10))); 
r = g + sqrt(No/2)* randn(1, length(g));

%Matched filter 
h=1;

output_h = conv(r,h);%matched filter for r by convolution 

%Plot output of the receive filter
len4=numberOfBits;
n4=200;
N4=n4*len4;
dt=len4/N4;
t4=0:dt:len4;
subplot(2,1,1); 
plot(t4,output_h);
axis([-2 110 -2 2]);
grid on;
title('Output of matched filter ');
xlabel('time   (sec)') 

%sampling at T & using thresholding operation
T = 1;
z=sign(output_h(T:end/numberOfBits:end)); 
decoded_bits=(z+1)/2; %Decoding the sent bits
%Calculate probability of error
cnt=0;
  for i=1:numberOfBits
       if (inputBits(i)~=decoded_bits(i))
           cnt=cnt+1;
       end
   end
   noOfWrongBits = cnt;
Probabilityoferror =  noOfWrongBits/numberOfBits  %calculating the bit error rate


%%%   Graph between BER nand  E/No   %%%
snr_db= -10:2:20;
E = 1;
No=(E ./(10.^(snr_db/10)));
nError = zeros(1,numberOfBits());
for k=1:length(No)
   r = g + sqrt(No(k)/2)* randn(1, length(g));
   output_h = conv( r, h);
   %sampling at T & using thresholding operation
   T = 1;
   z=sign(output_h(T:end/numberOfBits:end)); 
   decoded_bits=(z+1)/2; %Decoding the sent bits
   %Calculate probability of error
   cnt=0;
   for i=1:numberOfBits
       if (inputBits(i)~=decoded_bits(i))
           cnt=cnt+1;
       end
   end
   noOfWrongBits = cnt;
    BER(k)= (noOfWrongBits/numberOfBits); %calculating the bit error
end

%plotting BER Vs E/No
subplot(2,1,2)
semilogy(snr_db,BER)
axis([-11 10 -3 1]);

title ('BER Vs E/No');
xlabel ('E/No in db');
ylabel ('BER');
grid on;

 