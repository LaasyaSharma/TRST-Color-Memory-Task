% Checks if user has entered a correct value
% @param mainText -- text of the prompt, e.g. 'Please enter a numeric value'
% @param altText -- text of the warning, e.g. 'Incorrect input, please enter 1,2 or 3'
% @param correctValues -- array of expected inputs, e.g. [1,2,3]
function var = checkCorrectInput(mainText, altText, correctValues)
    while true
        var = input(sprintf(mainText),'s');
        var  = str2num(var);
        if isempty(var)
            disp('A numeric value is expected.');
        else
            if nargin < 3
                break;
            else
                if isempty(find(correctValues==var))
                    disp(altText);
                else
                    break;
                end
            end
        end
    end
end


