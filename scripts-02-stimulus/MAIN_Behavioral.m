%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------------------CROSS INHIBITION EXPERIMENT-----------------------%
%------------------------------- Stimulus --------------------------------%
%-------------------------------Version 1.0-------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ______________________________________________________________________
% |                                                                      |%
% | Authors: Alexandre Sayal, Teresa Sousa, Joao Duarte,                 |%
% |          Ricardo Martins, Gabriel Costa                              |%
% |                                                                      |%
% |                        CIBIT ICNAS 2018-2019                         |%
% |______________________________________________________________________|%
%
% Version 1.0 (18 06 2019)
% - Create public version
%
% Version 0.3 (12 11 2018)
% - Corrected keypress output
%
% Version 0.2 (05 11 2018)
% - Add Behavioural runs D6 and D12
%
% Version 0.1 (14 09 2018)
% - First

clear all; clc; Screen('CloseAll'); IOPort('CloseAll');

addpath('functions')
addpath('functions_main')
addpath('functions_mri')

S = struct();

%% Input
% --- Subject Name
S.SUBJECT = 'S00';
S.SUBJECT_ID = 'TT'; % 2 characters exactly

% --- Eyetracker, Trigger, Response box
S.EYETRACKER = 0;
S.TRIGGER = 0;
S.RSPBOX = 0;

% --- Screen number
% If screenNumber==50, initCrossInhib chooses the screen with the highest index.
screenNumber = 50;

%% Initialize
[ S ] = initCrossInhib( S , screenNumber );

Output = struct();
Output.S = S;

%% Load Textures
if exist(fullfile(S.input_path,sprintf('Textures_%i_R%i_sB%i_tB%i_l%i.mat',S.height,S.screenX,S.screenBackground,S.textBackground,S.lines)),'file') ~= 2
    tic
    [ T ] = buildTextures( S );
    fprintf('Build successful (%.2fs). \n',toc);
else
    tic
    load(fullfile(S.input_path,sprintf('Textures_%i_R%i_sB%i_tB%i_l%i.mat',S.height,S.screenX,S.screenBackground,S.textBackground,S.lines)));
    fprintf('Load successful (%.2fs). \n',toc);
end

%% Run Behav D6 R1
Output.('RunBehav_D6_R1') = runT( 'RunBehav_D6_R1' , S , T );

%% Run Behav D6 R2
Output.('RunBehav_D6_R2') = runT( 'RunBehav_D6_R2' , S , T );

%% Run Behav D6 R3
Output.('RunBehav_D6_R3') = runT( 'RunBehav_D6_R3' , S , T );

%% Run Behav D12 R1
Output.('RunBehav_D12_R1') = runT( 'RunBehav_D12_R1' , S , T );

%% Run Behav D12 R2
Output.('RunBehav_D12_R2') = runT( 'RunBehav_D12_R2' , S , T );

%% Run Behav D12 R3
Output.('RunBehav_D12_R3') = runT( 'RunBehav_D12_R3' , S , T );

%% Save Workspace
save(fullfile(S.output_path,...
    [ S.SUBJECT '_OUT_' datestr(now,'HHMM_ddmmmmyyyy')]),...
    'Output');

%% Close COMs
% Just because you are cool.
IOPort('Close',S.response_box_handle);
IOPort('Close',S.syncbox_handle);
