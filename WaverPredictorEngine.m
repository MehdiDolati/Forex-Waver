inputs=xlsread('EURUSD1440 Expert Waver ANN Test.csv');
targets = inputs(:,end-2);
inputs=inputs(:,7:end-9)';

%load('WaverNetworks.mat');

direction = round(EURUSDD1WaverDirectionNetwork(inputs))';
%value = EURUSDD1WaverValueNetwork(inputs)