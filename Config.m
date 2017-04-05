function Cfg = Config(subnb)

Cfg.run_mode = 'behav'; % 'mriScanner' or 'mriSimulator' or 'behav'
Cfg.Screenshot = 0;  %1 to take screenshots in each trial, 0 to not take any screenshot

A = [1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3];
Ashuffled=A(randperm(length(A)));
Bshuffled=A(randperm(length(A)));
Cshuffled=A(randperm(length(A)));

Practice = [1 2 3];
Cfg.conditions = {Practice, Ashuffled, Bshuffled, Cshuffled};


% RUNNING IN THE MR WITH LUMINA BOX EPSON IN MR
Cfg.Screen.xDimCm = 42;
Cfg.Screen.yDimCm = 34;
Cfg.Screen.distanceCm = 134;

Cfg.synchToScanner = 5;
Cfg.ScannerSynchShowDefaultMessage = 1;

if strcmp(Cfg.run_mode,'mriScanner')
    Cfg.synchToScannerPort = 'SERIAL';
    Cfg.scannerSynchTimeOutMs = Inf; %BY DEFAULT WAIT FOREVER
    Cfg.responseDevice = 'LUMINASERIAL';
    Cfg.serialPortName = 'COM1';
    Cfg.TR = 2.2;
elseif strcmp(Cfg.run_mode,'mriSimulator')
    Cfg.synchToScannerPort = 'SIMULATE';
    Cfg.scannerSynchTimeOutMs = 3000; %BY DEFAULT WAIT FOREVER
    Cfg.responseDevice = 'KEYBOARD';
else
    Cfg.responseDevice = 'KEYBOARD';
end

%% colors
if mod(subnb, 2)    % if subject number is odd
    Cfg.color1 = [153 0 56]; % loss: purple
    Cfg.color2 = [255 215 0];  % payoff: yellow
    Cfg.color3 = [100 100 100]; % regret: lightgrey
else                % if subject number is even
    Cfg.color1 = [100 100 100]; % loss: lightgrey 
    Cfg.color2 = [153 0 56]; % payoff: purple
    Cfg.color3 = [255 215 0];  % regret: yellow
end

% % Start PsychToolBox
% screens=Screen('Screens'); 
% screenNumber=max(screens); % Main screen 
% if strcmp(Cfg.run_mode,'mriScanner') || strcmp(Cfg.run_mode,'mriSimulator')
%     Cfg.Screen.skipSyncTests = 0;
%     oldRes=SetResolution(screenNumber,1280,1024,60);
% else
%     Screen('Preference', 'SkipSyncTests', 2); % 2 to skip tests, as we don't need milisecond precision, 0 otherwise
% end

%% timing parameters
Cfg.MaxDecisionTime = 10;
Cfg.MaxButtonTime = 2;

% for fMRI current order is fixation cross, validation,
% symbols_other, show owm choice
Cfg.Val_min = 2;
Cfg.Val_max = 4;
Cfg.Fix_min = 2;
Cfg.Fix_max = 4;

% behavior
Cfg.tFixation = 1.5; %time of cross on screen
Cfg.tVal = 1.0000; %parameter that we now have only in cfPost because being the response in cfTest self paced, we do not need it anymore
Cfg.tNoDecision = 3.0000; % decision screen without cursor
Cfg.tFeedback = 4.0000; % feedback time

%% keyboard parameters
KbName('UnifyKeyNames'); % Use same key codes across operating systems for better portability

switch Cfg.run_mode
    case {'mriScanner', 'mriSimulator_serial'}
        keyLeft     = 3;  % RED=52
        keyRight    = 4;  % BLUE=49
        keyVal = 1;
        unused = 2;
    case {'behav','behavior', 'mriSimulator'}
        keyLeft=KbName('leftArrow'); % Left arrow
        keyRight=KbName('rightArrow'); % Right arrow
end
escape = KbName('ESCAPE');