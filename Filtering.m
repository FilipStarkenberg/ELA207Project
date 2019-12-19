close all;
clc;
close all;
clc;

mat = dir("./EMG/*.csv");%put csv files in ./EMG/ to load all csv files.

for q = 1:length(mat) 
    load(mat(q).name);
end

sampelrate = 4000;  %samplerate
samples = 20000;    %total sampels in file
time = 5;           %time in seconds

t1 = [0:time/samples:time-time/samples];                        %t in time domain
t2 = [0:sampelrate/samples:sampelrate/2-sampelrate/samples];    %t in frequency domain

signal = HC_1(:,1);             %select signal

signal_fft = abs(fft(signal));%fft
signal_single_fft = signal_fft(1:length(signal_fft)/2);%format fft

figure;
plot(t2, signal_single_fft);%plot unfiltered signal in frequency spectrum
set(gca, 'xlim', [0 800]);


%notchspec = fdesign.notch('N,F0,Q',2,50,5,4000);
%notchfilt = design(notchspec,'SystemObject',true);



%Filter design
d1 = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',49,'HalfPowerFrequency2',51, ...
               'DesignMethod','butter','SampleRate',sampelrate);

d2 = designfilt('bandpassiir', 'FilterOrder',20, ... 
                'HalfPowerFrequency1',40,'HalfPowerFrequency2',440, ...
                'SampleRate',sampelrate);
           
%Filter signal;
f1 = filtfilt(d1,signal);
filtered_signal = filtfilt(d2, f1);

filtered_signal_fft = abs(fft(filtered_signal));            %fft
filtered_signal_single_fft = filtered_signal_fft(1:length(filtered_signal_fft)/2);%format fft

figure;
plot(t2, filtered_signal_single_fft);%plot filtered signal in frequency spectrum
set(gca, 'xlim', [0 800]);

figure;
plot(t1, signal);%plot original signal
figure;
plot(t1, filtered_signal);%plot filtered signal


diff_signal = HC_1(:,1) - HC_1(:,2);%diffrenciated signal
figure;
plot(t1, diff_signal);%plot diff signal

B = 1/100*ones(100,1);
out = filter(B,1,diff_signal);%get moving avrage signal
hold on;
%figure;
plot(t1, out, 'r');%plot moving avrage signal

