function res = audodd(varargin)
% ODDAUD - run auditory odd ball task
%   optionally specify a subject to not be prompted for one
% USAGE:
%  oddaud 001

%% DEALING WITH A PTB CRASH
% if psychtoolbox crashes before it can shutdown the screen
% you'll have to kill it manually (without visual feedback -- eg. wont be able to see what you type):
% 1. ctrl+c 
% 2. blindly type: sca [enter]
% 3. if nothing happens, alt+tab(+tab+tab...) to matlab and start at step 1 agin

%% SETTINGS
% times in seconds
start_hrf_wait = 1;   % should probably be >= 6
finish_hrf_wait= 1;   % should probably be >= 12
trial_dur      = 1.5; % how long is each trial
snd_load_time  =  .1; % how much time before trial end to devote to processing
                      %  no key press is accepted in this window

% Keys, later given to KbName 
scannerTrigger = '=+';
stdkey         = '1!';
trgkey         = '2@';

% empty means fullscreen, otherwise [topx,topy,width,height]
%screenRes      = []; 
screenRes      = [0 0 800 600]; 

counterbalance=0; % to be flipped based on subject id?

%% determin subjecject id
% either we gave it to the function, like 
%   oddaud('001')
%    OR
%   oddaud 001
% or we specified nothing, like
%   oddaud
%
% varargin is a matlab special syntax for functions: 'variable argument input'
% if no paramater is given to the function
%   varargin is an empty cell and we need to prompt for an id
% otherwise
%   first index of varargin is the subjid
%
% why allow both? 
%  * nice to call like `oddaud 001` b/c subjid is stored in matlab history
%  * when no subjid is given, the error message if requireing subject might be hard to diagnose
if isempty(varargin)
  subjid=input('subjid: ','s');
else
  subjid=varargin{1}; 
end

%% if counterbalance, swap acceptable keys
% TODO: make counterbalance rules
if counterbalance
 revkeys={trgkey,stdkey};
 [ stdkey,trgkey] = revkeys{:};
end

% record in matfile
task.counterbalance = counterbalance;
task.stdkey = stdkey;
task.trgkey = trgkey;

%% define subject mat and log file
% where to save logs and mat output files
% logs and mats exist thants to PTBsetup
nowstr = datestr(datevec(now),'yyyymmddHHMMSS');
savename=[ subjid '_' nowstr ];
logfile=fullfile('logs',[savename,'.txt'])
matfile=fullfile('mats',[savename,'.mat'])

%% keep track of everything
diary(logfile)
fprintf('starting task for %s @scannerStart=%.02f\n',subjid,scannerStart)l


%% setup decent psychtoolbox defaults
% this is a custom function 
% w is the handle to the window 'sceen' that can be drawn on
% we need 'w' to 
%  1. dispaly instructions
%  2. draw fixation cross
%  3. close the window when we finish
w = PTBsetup(screenRes); 

% needed Unified Keys called in PBsetup before using KbName

% std key first, so waitForKey returns 1 means standard, 2 means target
% or at least thats the logic scoreResponse should use
scannerKey     = KbName(scannerTrigger)
acceptKeys     = KbName({stdkey,trgkey});

%% get sounds
[snds sndlist] = loadSounds();

% hack to initialize audio handler
pahandle = playsnd([],[]);


%% instructions
% a custum function in the same directory as this script 
% could be called on its own like: instructions(PTBsetup([]))
instructions(w,snds,acceptKeys);


%% Scanner Startup

% wait for the scanner to send a trigger
waitforscannertxt=sprintf('Waiting For Scanner (%s)',scannerTrigger);
DrawFormattedText(w,waitforscannertxt,'center','center');
Screen(w,'Flip');

[~,ScannerStartTime]=waitForKey(scannerKey,Inf);
fprintf('scannerStart\t%.02f\n',scannerStart);


% bring up fixation screen (last screen flip -- screen doesn't change after this)
fixation(w,[]);

% wait some second before starting to give deconvolve some time of just fixation
WaitSecs(start_hrf_wait);

% record the different times (when the scanner started vs when the task started
task.ScannerStart=ScannerStartTime;
task.TaskStart=GetSecs();


%% main loop
for trial_number=1:length(sndlist)
 % when should this trial start. 
 % aboslute timing (instead of relative to previous) so each sound starts when expected
 % import to maintain rythm of task
 thisIdealStart = task.TaskStart + (trial_number - 1) * trial_dur;

 % how long can we wait for a response -- 100ms before stating next trial 
 % -- give the computer some time to score,print, and load the next audio file
 thisMaxEnd = thisIdealStart + trial_dur - snd_load_time;

 % which sound are we playing on this trial
 sndname = sndlist{trial_number};
 snd = snds.(sndname);

 % run task
 % update array of timing structures with trail info
 trial_info = runTrial(sndname,snd,acceptKeys,thisIdealStart,thisMaxEnd);


 % print what happened for diary logging in case of mat corruption
 fprintf('trial %02d\tpushed %d\tscore %d\tRT %.02f\tsndon %.02f\tsnd %s\n',...
   trial_number, trial_info.response, ...
   trial_info.correct, trial_info.rt,...
   trial_info.onset-ScannerStartTime,trial_info.sndname);

 task.timing(trial_number) =  trial_info;

 % save every iteration incase of a crash
 %TODO: reconsider save at each trial 
 % does this cause any time pentilty not worth paying?
 % do we exepct crashes that we want to keep data for
 % (have emergancy data in log/diary file in this case)
 save(matfile,'task')
end

finishTime=GetSecs();
fprintf('Finished Main Loop\t%.02f\n',finishTime);

%% finish with fixation for hrf relaxation
WaitSecs(finish_hrf_wait);
cleanupTime=GetSecs();
fprintf('cleanup\t%.02f\n',cleanupTime);

%% final save
task.finishtime= finishTime;
task.cleanuptime= cleanupTime;
save(matfile,'task')

cleanup();

end
