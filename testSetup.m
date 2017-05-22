cleanup
fprintf('can we setup a window?\n');
w= PTBsetup([0 0 800 600]);
if ~isempty(w); fprintf('YES\n'); else fprintf('!!NO!!\n'); end
fprintf('and draw a fixation\n');
onset=fixation(w,[])
if ~isempty(onset) & onset>0; fprintf('YES\n'); else fprintf('!!NO!!\n'); end

fprintf('can we load all the sounds?\n');
[snds,sndlist] = loadSounds();
if ~isempty(sndlist); fprintf('YES\n'); else fprintf('!!NO!!\n'); end


fprintf('can we play all the sounds?\n');
playsnd([],[]);
for sndname=unique(sndlist)
  playsnd(snds.(sndname{1}),0);
end

fprintf('\n\ndoes the button box work?\n');
fprintf('\tpush finger 1:');
waitForKey(KbName('1!'),Inf);
fprintf('\n\tpush finger 2: ');
waitForKey(KbName('2@'),Inf);
fprintf('\n');


cleanup
