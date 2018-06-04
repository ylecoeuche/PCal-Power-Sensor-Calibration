% Template: pcalScriptTemplate_CalcRat
%
% This m-script calculates device response ratios from two devices from the
% measurement data obtained on Pcal Power Calibration Standards setup in
% the LSB lab.

% Generated TIMESTAMP
timestamp = '2018-05-03T1656';

% Short TIMESTAMP
ts = 'D20180503T1656';

% Devices
dev1 = 'GS';
dev2 = 'WS1';

% Generated file names
dirname = '2018-05-03T1656_rat_WS1_GS';
dev1ReflFilename = '2018-05-03T1656_meas_GSRefl.csv';
dev2TranFilename = '2018-05-03T1656_meas_WS1Tran.csv';
dev1TranFilename = '2018-05-03T1656_meas_GSTran.csv';
dev2ReflFilename = '2018-05-03T1656_meas_WS1Refl.csv';

ScriptForThisRun = 'D20180503T1656_CalcRat_WS1_GS.m';

% Loading time series
dev1Refl = pcalLoadValues(dev1ReflFilename);
dev2Tran = pcalLoadValues(dev2TranFilename);
dev1Tran = pcalLoadValues(dev1TranFilename);
dev2Refl = pcalLoadValues(dev2ReflFilename);

% Average background levels, must input these values manually.
dev1ReflBg = 0.000119888;
dev2TranBg = -0.000202102;
dev1TranBg = 0.000129211;
dev2ReflBg = -0.000201739;

% Subtracting background averages from the time series
dev1Refl = dev1Refl - dev1ReflBg;
dev2Tran = dev2Tran - dev2TranBg;
dev1Tran = dev1Tran - dev1TranBg;
dev2Refl = dev2Refl - dev2ReflBg;

% Plot
pcalPlotMeasPair([dev1, 'Refl'], [dev2, 'Tran'], dev1Refl, dev2Tran, 'startfig', 1);
pcalPlotMeasPair([dev1, 'Tran'], [dev2, 'Refl'], dev1Tran, dev2Refl, 'startfig', 4);

% Ratio calculation
[rat_dev2_dev1, rat_R_T, StatData] = pcalRatMeanMethod(dev1Refl, dev2Tran, dev1Tran, dev2Refl);

fprintf('Ratio of responses: WS1/GS = %.6e\n', rat_dev2_dev1);
fprintf('Beamsplitter ratio: R/T = %.6f\n', rat_R_T);

fid = fopen('setPCAL_D20180503T1656_RAT_WS1_GS.m', 'w');
fprintf(fid, '%% Setting variable PCAL_D20180503T1656_RAT_WS1_GS,\n');
fprintf(fid, '%% which is ratio of WS1 response over GS response measured on 2018-05-03T1656.\n');
fprintf(fid, 'PCAL_D20180503T1656_RAT_WS1_GS = %.6e;\n', rat_dev2_dev1);
fclose(fid);

%{
% SVN terminal window commands to be executed from "LabData/" upon
% completion of measurement procedure to upload files onto server:

svn add 2018-05-03T1656_rat_WS1_GS
svn commit -m "Pcal. 2018-05-03T1656, ratio WS1 / GS measurements."
svn update

%}
