clear noisyec; 
clear a; 
arduino('COM4', 'Uno'); 
configurePin(a, 'D10'); 
configurePin(a, '111'); 
C=0; 
data=[];
while(c<100)
    v=readvoltage(a, "A0");
    X= V; 
    C=C+1; 
    noisyec(c, 1) = v; 
    plot(noisyec);
    xlim([0.0 100.0]); 
    ylim([0.00 3.00]);
    title('ECG Signals from arduino'); 
    xlabel('milliseconds'); 
    ylabel('millivolts');
end
t=(1:length(noisyec));
subplot(2,1,1);
plot(t, noisyec);
grid;
title('ECG Signals with Trends');
ylabel('Voltage (mv)'); 
dt_noisyec = detrend (noisyec); 
subplot(2,1,2); 
plot(t, dt_noisyec); 
grid;
title('Detrended ECG Signals'); 
ylabel('Voltage (mv)');
% Visualize results
clf;
plot(noisyec, 'Color', [109 185 226]/255, 'DisplayName', 'Input data');
hold on;
plot(dt_noisyec,'Color', [0 114 189]/255, 'LineWidth',1.5,...
'DisplayName', 'Detrended data');
plot(noisyec-dt_noisyec,'Color', [217 83 25]/255, 'LineWidth',1,...
'DisplayName', 'Trend');
hold off ;
legend;
xlabel('milliseconds');
ylabel('millivolts');
ismax = islocalmax(dt_noisyec, 'MinProminence',0.9);
clf
plot(dt_noisyec, 'Color', [109 185 226]/255, 'DisplayName', 'Input data');
hold on
plot(find(ismax), dt_noisyec(ismax),'^', 'Color', [217 83 25]/255,...
'Marker FaceColor', [217 83 25]/255, 'DisplayName', 'local maxima');
title(['Number of extrema: ' num2str(nnz(ismax))]); 
hold off; 
legend; 
xlabel('milliseconds'); 
ylabel('millivolts');
%heart rate calculations 
maxIndices = find(ismax);
msPerBeat = mean (diff(maxIndices)); 
heartRate = 60* (100/msPerBeat); 
disp("HEART RATE: "+ heartRate); 
if heartRate <= 60
    disp('Bradycardia , it is slower than normal heart rate'); 
elseif heartRate >=60 && heartRate<=100
    disp('A normal heart rate');
elseif heartRate >=100 && heartRate<=150
    disp('Tachycardia, it is faster than normal heart rate'); 
elseif heartRate >=150 && heartRate<=180
    disp('Supraventricular Tachycardia'); 
elseif heartRate >=180 && heartRate<=200
    disp('Fetal tachyarrhythmia'); 
elseif heartRate>200
    disp('Paroxysmal supraventricular tachycardia'); 
end
