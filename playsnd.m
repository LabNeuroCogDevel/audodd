function onset = playsnd(snd,idealtime)
% PLAYSND -- play a given sound at a given time
% interally stores handle to sound card 'pahandle'
% KLUDGY DIRTY HACK to initialize or get pahandle:
%  pahandle=playsnd([],[])

 %% keep pahandle local to this function
 persistent pahandle
 if isempty(pahandle)
  % settings for all sounds, enforced by loadSounds.m
  freq=44100;
  nrchannels=2;

  pahandle = PsychPortAudio('Open', [], [], 0, freq, nrchannels);
 end

 % just called to initialize pahandle
 % or to get pahandle
 if isempty(snd)
   onset=pahandle; 
   return;
 end

 PsychPortAudio('FillBuffer', pahandle, snd');
 %                      'Start',handle   ,reps,when     ,waitforstart,stoptime,resume
 onset = PsychPortAudio('Start', pahandle,   1,idealtime,           1);
end
