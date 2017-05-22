function instructions(w,snds,acceptkeys)

 % N.B.  * matlab '...' allows us to breakup what would be a single line into multiple lines
 %         so this is a 1xN array (NxM would break PTB's drawFormattedText)
 %       * '\n' means newline (mimic enter)


 txt = [...
   'In this task, you will hear sounds. For each sound,\n'...
   'your job is to decide if the sound is the target or not.\n'...
   'If the sound IS the TARGET,\n'  ...
   'press the LEFT button.\n' ...
   '\n'...
   'If the sound IS NOT the TARGET,\n' ...
   'press the RIGHT button.' ...
 ];

 %% show instructions

 % use inline function (in code at bottom of file)
 % to draw the text and wait for any key to be pushed
 drawAndKey(w,txt)


 %% test the sounds

 % standard
 drawAndKey(w,'Ready for the std sound?');
 playsnd(snds.std,GetSecs());

 % target
 drawAndKey(w,'That was standard. Next is target');
 playsnd(snds.tgt,GetSecs());

 % both
 drawAndKey(w,'Now we will play standard then target');
 playsnd(snds.std,GetSecs());
 WaitSecs(.5)
 playsnd(snds.tgt,GetSecs());

 %% if function was given acceptable keys
 % test the subject knows them
 if ~isempty(acceptkeys)
   drawAndKey(w,'Lets Pratice');
   exampleTrial(w,snds,'std',acceptkeys);
   exampleTrial(w,snds,'tgt',acceptkeys);
 end
 
 % all done with the instructions
 drawAndKey(w,'Now Lets play the game');

end

function drawAndKey(w,txt)
 %% display text
 txtColor=[0 0 0]; % rgb: black

 txt=[txt '\n\nPush any key'];
 DrawFormattedText(w, txt, 'center','center', txtColor);
 % "flip" what we've drawn onto the display
 Screen('Flip', w);
 % wait 300 seconds, then advance after keypress
 WaitSecs(.3);
 KbWait();
end

function exampleTrial(w,snds,sndname,acceptkeys)
   correctTxt='Great!';
   wrongTxt='Try Again';

   info.correct=0;
   while(~info.correct)
      fixation(w,[]);
      info=runTrial(sndname,snds.(sndname) ,acceptkeys,GetSecs(),GetSecs()+2);
      if(~info.correct) 
        drawAndKey(w,wrongTxt);
      else
        drawAndKey(w,correctTxt);
      end
   end
end
