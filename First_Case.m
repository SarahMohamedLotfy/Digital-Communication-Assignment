N=10000; % Number of input bits
sent_bits=randi([0,1],1,N); %Input Bit Stream
A=1; %amplitude of S(t)
T=1; %duration of S(t)
S = ones(1,T)*A; %rectangular pulse
E = norm(S)^2; %S(t) Energy
h=fliplr(S); %matched filter
bits=(2*sent_bits-1); 
g=kron(bits,S);  %Signal that represents bit stream
 

snr_db= 20;
No=(E ./(10.^(snr_db/10)));
w=randn(1,length(g))*sqrt(No/2); %add noise 
r=g+w; %received signal
output_h=conv(r,h);   %matched filter for r by convolution 

%Plot output of the receive filter at snr_db = 20  for 5 bits
subplot(2,1,1); 
plot(output_h);
axis([-2 110 -2 2]);
grid on;
title('Output of matched filter');
xlabel('time   (sec)') 


z=sign(output_h(T:T:end)); %sampling at T & using thresholding operation
decodedBits=(z+1)/2; %Decoded Bits

%Calculate number of wrong bits
cnt=0;
  for i=1:N
       if (sent_bits(i)~=decodedBits(i))
           cnt=cnt+1;
       end
   end
   noOfWrongBits = cnt;
  
Probabilityoferror =  noOfWrongBits/N   %calculating the bit error rate

snr_db= -10:2:20;
No=(E ./(10.^(snr_db/10)));
for k=1:length(No)
   w=randn(1,length(g))*sqrt(No(k)/2); 
   r=g+w; 
   output_h=conv(r,h); 

   z=sign(output_h(T:T:end)); 
   decodedBits=(z+1)/2;
   cnt=0;
   for i=1:N
       if (sent_bits(i)~=decodedBits(i))
           cnt=cnt+1;
       end
   end
   noOfWrongBits = cnt;
   BER(k)= (noOfWrongBits/N);  %Bit error rate
end
 
%plotting BER Vs E/No
subplot(2,1,2)
semilogy(snr_db,BER)
axis([-11 9 -3 1]);

title ('BER Vs E/No');
xlabel ('E/No in db');
ylabel ('BER');
grid on;