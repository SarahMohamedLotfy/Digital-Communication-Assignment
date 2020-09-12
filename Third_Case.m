N=100;   % Number of input bits
sent_bits=randi([0,1],1,N); %Input Bit Stream
A=1; %amplitude of S(t)
T=1; %duration of S(t)
S=ones(1,T)*A; %rectangular pulse
E=norm(S)^2; %S(t) Energy
 
% g signal represent bit stream
len=N;
n=200;
dt=(n*len)/N;
t1=0:dt:len;
g=zeros(1,length(t1));
for i=0:len-1;
    if sent_bits(i+1)==1
        g(i*n+1 : (i+1)*n)=1;
    else
        g(i*n+1 : (i+1)*n)=-1;
    end;
end;

t = 0:0.01:1;
h = (sqrt(3))* t; %matched filter

snr_db=20 ;
E = 1;
No=(E ./(10.^(snr_db/10)));
w=randn(1,length(g))*sqrt(No/2); %add noise 
r = g+w; %received signal
output_h=conv(r,h); %matched filter for r

%plotting output of matched filter
subplot(2,1,1); 
plot(output_h);
grid on;
title('Output of matched filter');
xlabel('time   (sec = 100 in graph)') % 2*10^4 = 200

z=sign(output_h(T:T:end)); %sampling at T & using thresholding operation
decodedBits=(z+1)/2; %decoding the sent bits
length(decodedBits)
 cnt=0;
  for i=1:N
       if (sent_bits(i)~=decodedBits(i))
           cnt=cnt+1;
       end
   end
   noOfWrongBits = cnt;
Probabilityoferror =  noOfWrongBits/N  %calculating the bit error


snr_db= -10:2:20;
E = 1;
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
   BER(k)= noOfWrongBits/N; 
end
 
%plotting BER Vs E/No
subplot(2,1,2)
semilogy(snr_db,BER)
axis([-11 21 -3 1]);
title ('BER Vs E/No');
xlabel ('E/No dB');
ylabel ('BER');
grid on;