function instructions(w)
 %% display text
 txtColor=[0 0 0]; % rgb: black

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
 DrawFormattedText(w, txt, 'center','center', txtColor);
 % "flip" what we've drawn onto the display
 Screen('Flip', w);

 % TODO:
 %  test subject knows which key is which

end
