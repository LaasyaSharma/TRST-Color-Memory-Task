% End of experiment window
% @param color -- text color
% @param text -- message to show
% @param textSize -- size of the text
% @param window -- screen window

function showEoeWindow(color, text, textSize, window)
    FlushEvents;
    Screen('TextSize', window, textSize);
    DrawFormattedText(window, text, 'center', 'center',color);
    Screen('Flip', window);
    ourKeyPressed = 0;

    while ~ourKeyPressed
          [keyIsPressed,secs, keyCode, deltaSecs] = KbCheck();
          if keyIsPressed
             if keyCode(KbName('SPACE'))
                    ourKeyPressed = 1;
             end
          end
    end
    FlushEvents;
    WaitSecs(0.2);
end



