function cleanup()
   try
     pahandle=playsnd([],[]);
     PsychPortAudio('Close', pahandle);
   end
   sca;
   diary off;
end
