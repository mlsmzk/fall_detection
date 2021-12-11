function [possible_fall] = analyzeFall(file_name, bounds,threshold,skip)
% Use our summing algorithm to detect where a fall occurs in accelerometer
% data

% file_name is a string corresponding to a .mat file located in the same
% folder that this function should be.

if nargin < 3
    threshold = 10^3*7;
    skip = 5;
end

if nargin == 3
    skip = 5;
end

load(file_name);
x=Acceleration.X;
y=Acceleration.Y;
z=Acceleration.Z;

low_bound = bounds(1);
high_bound = bounds(2);
fs=1000;

figure;
%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
% FOR PLOTTING LATER %
%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
m=vecnorm([x(:,1),y(:,1),z(:,1)]');
for d = (1:length(m))
    t(d)=d/fs;
end
%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
subplot(2,2,1)
plot(t,m)
title('Magnitude of Acceleration')
xlabel('Time (s)')
ylabel('Acceleration (m/s)^2')

% Plot the STFT of the signal in a default window size
subplot(2,2,3)
stft(m ,fs,'Window',rectwin(100),'OverlapLength',90,'FFTLength',1000);
mstft1=stft(m ,fs,'Window',rectwin(100),'OverlapLength',90,'FFTLength',1000);
ylim([0;10])

% Plot the STFT of the signal in a zoomed in window size, focused on the
% interval or interest.
subplot(2,2,4)
stft(m ,fs,'Window',rectwin(100),'OverlapLength',90,'FFTLength',1000);
ylim([low_bound;high_bound])

%bound frequency
frequency_bounded_mstft=mstft1(500+low_bound:500+high_bound,:);

%normalize
for i =(1:length(frequency_bounded_mstft(:,1)))
    for j =(1:length(frequency_bounded_mstft(1,:)))
frequency_bounded_mstft_real(i,j)=norm(frequency_bounded_mstft(i,j));
    end
end

%sum frequencies in each time band
%the highest sum indicates the spectrum with the highest amplitudes -- most
%likely to occur at a fall

for k =(1:length(frequency_bounded_mstft_real(1,:)))
    sum_frequency_bounded_mstft_real(1,k)=sum(frequency_bounded_mstft_real(:,k));
end

possible_fall=[];
w=1;

try
    while w <length( sum_frequency_bounded_mstft_real(1,:))
        if sum_frequency_bounded_mstft_real(1,w)>threshold
            possible_fall=[possible_fall,w*length(x)/length(sum_frequency_bounded_mstft_real(1,:))];
            w=w+skip;
        end
        w=w+1;
    end
    subplot(2,2,2)
    plot(m)
    title('Magnitude of Acceleration')
    xlabel('Time (s)')
    ylabel('Acceleration (m/s)^2')
    for e=(1:length( possible_fall(1,:)))
        xline(possible_fall(1,e),'--r',{'Acceptable','Limit'})
    end
catch length(possible_fall) == 0;
    disp('No one fell!')

end

subplot(1,1,1)
plot(m)
title('Magnitude of Acceleration')
xlabel('Time (s)')
ylabel('Acceleration (m/s)^2')
for e=(1:length( possible_fall(1,:)))
    xline(possible_fall(1,e),'--r',{'Acceptable','Limit'})
end
end


