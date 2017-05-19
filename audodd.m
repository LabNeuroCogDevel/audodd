function res = oddaud(varargin)
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
  subjid=input('subjid: ');
else
  subjid=varargin{1}; 
end


%% setup decent psychtoolbox defaults
% this is a custom function in the 'private' directory
% w is the handle to the window 'sceen' that can be drawn on
% we need 'w' to 
%  1. dispaly instructions
%  2. draw fixation cross
%  3. close the window when we finish
screenResolution=[]; % empty means fullscreen
w = PTBsetup(screenResolution); 

%% get sounds
snds = loadSounds();


%% instructions
% a custum function in the same directory as this script 
% could be called on its own like: instructions(PTBsetup([]))
instructions(w);



end
