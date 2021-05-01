function a = getADSR(target,gain,duration)
% Input
%   target - vector of attack, sustain, release target values
%   gain - vector of attack, sustain, release gain values
%   duration - vector of attack, sustain, release durations in s
% Output
%   a - vector of adsr envelope values
% Copied from Music Synthesis using Sinusoid Generator, ADSR Envelope Generator and Composer Code
% Author: Tony Mathew, Bimal M Abraham, Robin Scaria
% Editor: Yuang Cheng, 2020/05/04
fs = 48000;% sampling rate
a = zeros(fs*sum(duration),1);
duration = round(duration.*fs); % envelope duration in samp
% Attack phase
start = 2;
stop = duration(1);
for n = start:stop
 a(n) = target(1)*gain(1) + (1.0 - gain(1))*a(n-1);
end
% Sustain phase
start = stop + 1;
stop = start + duration(2);
for n = start:stop
 a(n) = target(2)*gain(2) + (1.0 - gain(2))*a(n-1);
end
% Release phase
start = stop + 1;
stop = sum(duration);
for n = start:stop
 a(n) = target(3)*gain(3) + (1.0 - gain(3))*a(n-1);
end