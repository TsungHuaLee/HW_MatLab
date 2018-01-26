clc;
clear all;
close all;
filename = {'1.wav', '2.wav','3.wav','mix.wav'};
for k = 1 : length(filename)
    [wave,fs1] = audioread(filename{k});
    
    %time domain
    figure(1);
    plot(wave);
    xlabel('Time');
    ylabel('amplitude');
    title 'wav signal';
    %??????
    left=wave(:,1);
    right=wave(:,2);
    %spectral view
    figure(2);
    spectrogram(left,256,250,256,fs1,'yaxis');
    %frequency domain
    figure(3);
    temp = fft(left);
    temp2 = fftshift(temp);
    plot(abs(temp2));
    sound(wave,fs1);
    pause(1);
end