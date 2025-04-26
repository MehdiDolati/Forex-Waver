%% Start of Program
clc
clear
close all

%% Data Loading
data=xlsread('EURUSD1440 Waver ANN.csv');
inputs = data(:,7:end-9);
targets = data(:,end-7);


%% Network Structure
pr = [-1 1];
PR = repmat(pr,size(inputs,2),1);

EURUSDD1WaverValueNetwork = feedforwardnet([25 25]);
% newff(PR,[20 20 OutputNum],{'logsig'  'logsig' 'purelin'});
EURUSDD1WaverValueNetwork.divideFcn = 'dividerand';
EURUSDD1WaverValueNetwork.trainParam.max_fail = 15;
EURUSDD1WaverValueNetwork.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
  'plotregression', 'plotfit'};

EURUSDD1WaverValueNetwork.divideParam.trainRatio = 70/100;
EURUSDD1WaverValueNetwork.divideParam.valRatio = 15/100;
EURUSDD1WaverValueNetwork.divideParam.testRatio = 15/100;

%% Preprocessing
% Network.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
% Network.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};

%% Training
[EURUSDD1WaverValueNetwork,tr] = train(EURUSDD1WaverValueNetwork,inputs',targets');
outputs = EURUSDD1WaverValueNetwork(inputs');

%% Assesment

trainInput = inputs(tr.trainInd);
validationInput = inputs(tr.valInd);
testInput = inputs(tr.testInd);

trainTarget = targets(tr.trainInd);
validationTarget = targets(tr.valInd);
testTarget = targets(tr.testInd);

trainOutpout = outputs(tr.trainInd)';
validationOutpout = outputs(tr.valInd)';
testOutpout = outputs(tr.testInd)';

%% Display
plotregression(targets, outputs);
%save WaverNetworks.mat -append EURUSDD1WaverValueNetwork