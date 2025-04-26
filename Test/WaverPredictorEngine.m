inputs=xlsread('EURUSD1440WaverFeeder12 3.csv');
valueTargets = inputs(:,end-9);
directionTargets = inputs(:,end-3);
inputs=inputs(:,7:end-10)';
load('WaverNetworks.mat');

direction = round(EURUSDD1WaverDirectionNetwork(inputs));

value = EURUSDD1WaverValueNetwork(inputs)';
outputs = direction';
