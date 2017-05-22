# Auditory odd ball
`audodd` is a task rewritten for Pitt MRRC using [psychtoolbox](http://psychtoolbox.org/).

It is adapted from the task developed by xxx described in *[Auditory Oddball fMRI in Schizophrenia: Association of Negative Symptoms with Regional Hypoactivation to Novel Distractors](https://doi.org/10.1007/s11682-008-9022-7)*.

## Usage

In matlab or octave with psychtoolbox installed:

```matlab
%% RUN
audodd 001

%% EXPLORE
mat001 = load('mats/001_20170522131351.mat' );
rt = [mat001.task.timing.rt];
crct = [mat001.task.timing.correct];
% mean: all, correct, incorrect
[ mean(rt(rt>0)), mean(rt(crct)), mean(rt(~crct & rt>0 )) ]
```

## Notes

* limit impossibly quick responses w/ `waitForKey.m:fastestResponseTime`. set to 60ms.

## Files and Editing

all functions have minimal help. In Matlab/ocatve, see e.g. `help audodd`.

* `audodd.m` -- edit to change response keys and screen size | entrence to task, general wrapper

* `testSetup.m` -- run to test functions on a new computer, edit if new problems need to be tested

* `PTBsetup.m` -- edit to change bg color | general psychtoolbox setup, launch screen
* `instructions.m` -- edit to change instructions | dispalys instructions on a screen
* `loadSounds.m`  -- edit to change sounds and order | load (cache) sounds and set play order
* `fixation.m`  -- edit to change size/color of fixation cross | show fixation cross
* `runTrial.m` -- edit to change what trial info recorded | run a trial 
* `waitForKey.m` -- edit to change fastest allowable response time | return response and keypress time
* `stimuli/*wav` -- actual sound stimuli. TODO: fix freq of std and target
* `playsnd.m`  -- helper, no need to edit

### testing/exploring individual functions

```matlab
w = PTBsetup([0 0 800 600]);    % create a small screen
[snds, sndlist] = loadSounds(); % load up all sounds we will use

% look at fixation cross (need w)
fixation(w,[])

% play a sound (needs snd)
playsnd(snds.std,0)

% test insturctions (need w and snd)
instructions(w,snds,[]);
% test instructions with subject snd test
instructions(w,snds,KbNames({'a','b'}));

% test keybaord input (needs no extra variables)
[r k] = waitForKey(KbName('a'),Inf)
[r k] = waitForKey(KbName({'a','b'}), GetSecs()+2 )

% run a full trial (need snds)
runTrial('std',snds.std ,KbName({'a','b'}),GetSecs(),GetSecs()+2)
```

