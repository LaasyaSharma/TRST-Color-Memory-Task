%  This is a very simple template of experiment with triangular stimulus
%  TRST Unstructured -- Triangle Rotated Stimulus Test following the unstructured
%  programming paradigm

clear all
close all

Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'Verbosity', 0);

addpath('supportFiles')

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Load parameters
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   show/hide cursor on probe window
hideCursor = true;

%   to set the demo mode with half-transparent screen
isDemoMode = false;

%   screen transparency in demo mode
transparency = 0.8;

%   to make screen background darker (close to 0) or lighter (close to 1)
greyFactor = 0.6; 


viewDistance = 60;%default

%---------------------------------------------------------------------%
% study parameters
%---------------------------------------------------------------------%
%    set the name of your study
currentStudy = 'TRST';

%    set the version of your study
currentStudyVersion = 1;

%    set the number of current run
runNumber = 1;

%    set the name of current session (modifiable in the command prompt)
session = 1;

%    set the subject id (modifiable in the command prompt)
subjectId = 0;

%---------------------------------------------------------------------%
% data and log files parameters
%---------------------------------------------------------------------%

%   default name for the datafiles -- no need to modify. The program 
%   will set the name of the data file in the following format:
%   currentStudy currentStudyVersion subNumStr  session '_' runNumberStr '_' currentDate '.csv'
datafile = 'unitled.csv';
matfile = 'untitled.mat';

%   default name for the taskmap files -- no need to modify. The program 
%   will set the name of the data file in the following format:
%   currentStudy currentStudyVersion subNumStr  session '_' runNumberStr '_' currentDate '_taskMap.mat'
taskMapFile = 'untitled_taskMap.mat';

%   default name for the log file -- no need to modify. The program 
%   will set the name of the data file in the following format:
%   currentStudy currentStudyVersion subNumStr  session '_' runNumberStr '_' currentDate '_log.txt'
logFile = 'untitled_log.txt';

%---------------------------------------------------------------------%
% experiment  parameters
%---------------------------------------------------------------------%

%   set the number of trials in your experiment
numberOfTrials = 10;

% Coding Challenge Question 4:
% Divide the experiment into blocks.
numBlocks = 2;

trialsPerBlock = numberOfTrials/numBlocks;
%---------------------------------------------------------------------%
% tasks durations ( in seconds)
%---------------------------------------------------------------------%

%   sample task duration
sampleDuration = 0.5; 

%   delay duration between stimuli
delayTaskDuration = 0.25;

%   feedback window duration
feedBackTime = 1.5;

%   pre-trial task duration
preTrialTaskDuration = 1;

%   delay between two consecutive bet-placing tasks (appears in 
%   practice part only in showNewTrialStartWarningWindow())
intertrialTaskDuration = 1;

%   how long the get ready message appears before the start of the
%   first trial
getReadyTaskDuration = 3;

%---------------------------------------------------------------------%
% Some string resources 
%---------------------------------------------------------------------%
welcomeMsg = sprintf(['Welcome!\n\n' ...
'Remember the orientation of the triangle.\n' ...
'Use the mouse to reproduce the remembered orientation.\n\n' ...
'Keep your eyes on the central fixation cross.\n\n' ...
'Press SPACE to begin.']);
getReadyMsg = sprintf('Get ready...');
thankYouMsg = sprintf('Thank you for your participation!!! \n Please press SPACE to exit the experiment.');

%---------------------------------------------------------------------%
% Some geometry parameters
%---------------------------------------------------------------------%

%   Here we set the size of the arms of our fixation cross in degrees
fixationCrossSizeDeg = 0.2;

%   size of fixation cross in pixels by default -- no need to modify
fixationCrossSizePix =10; % size of fixation cross in pixels by default

%   set the line width for our fixation cross in degrees
lineWidthDeg = 0.05;

%  line width for our fixation cross in pixels by default -- no need to
%  modify
lineWidthPix = 2;

%	set the radius of the central circle for the probe task in degrees
rhoCircleDeg = 8.5;

%	default radius of the central circle for the probe task in pixels
rhoCirclePix = 300; 

%   set the triangle parameters in degrees
triangHeightDeg = 5;
triangWidthDeg = 2.5;

%   default triangle parameters in pixels, will be overwritten by
%   program
triangHeight= 250;
triangWidth = 125;

%	set the fond size
textSizeDeg = 0.8;

%	default value for the font size -- no need to modify
textSize = 30;

% max  score can be earned for one trial
maxScore = 100;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Initialize the subject info
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

runNumber = runNumber;
currentStudy = currentStudy;
currentStudyVersion = currentStudyVersion;

subNum = checkCorrectInput('Please type subject number: ');
session = checkCorrectInput('Please type session number: ');


subjectId = subNum;
session = session;


% Create all necessary directories (a directory for each subject, containg Results and TaskMaps)
%--------------------------------------------------------------------------------------------------------------------------------------%
% specify the directories to be used
CWD = [pwd '/']; %current working dir
ALL_SUB = [CWD 'SubjectDataWMouse/']; % create "SubjectData" dir that will contain all the data for all subjects
SUB_DIR = [ALL_SUB num2str(subNum) '/']; % create a "SubNum" dir inside the "SubjectData" dir
TASK_MAPS = [SUB_DIR 'TaskMaps/'];  % create a "TaskMaps" dir inside the "SubNum" dir
RESULTS_DIR = [SUB_DIR 'Results/']; % create a "Results" dir inside the "SubNum" dir
LOG_DIR = [SUB_DIR 'Logs/']; % create a "Logs" dir inside the "SubNum" dir

if exist(ALL_SUB,'dir')~=7
    mkdir(ALL_SUB);
end

%create a "SubNum" dir inside the "SubjectData" dir 
if exist(SUB_DIR,'dir')~=7 %if the "subNum" directory doesn't exist, create one
    mkdir(SUB_DIR);
end

 %create a "Results" dir inside the "SubNum" dir
if exist(RESULTS_DIR,'dir')~=7 %if the "Results" directory doesn't exist, create one
    mkdir(RESULTS_DIR);
    fprintf('making new results directory for subject %s...\n',num2str(subNum))
end

%create a "TaskMaps" dir inside the "SubNum" dir
if exist(TASK_MAPS,'dir')~=7 %if the "TaskMaps" directory doesn't exist, create one
    mkdir(TASK_MAPS);
    fprintf('making new task map directory for subject %s...\n',num2str(subNum))
end

%create a "logs" dir inside the "SubNum" dir
if exist(LOG_DIR,'dir')~=7 %if the "TaskMaps" directory doesn't exist, create one
    mkdir(LOG_DIR);
    fprintf('making new log file directory for subject %s...\n',num2str(subNum))
end

% Initialize the files to write in
%--------------------------------------------------------------------------------------------------------------------------------------%
%specify naming format for the data file
currentDateVector = datevec(date);
currentYear = currentDateVector(1)-2000;
currentMonth =currentDateVector(2);
currentDay = currentDateVector(3);

% Coding challenge question 1:
% Added hours, minutes, and seconds to filename 
% prevent result, log from being overwritten on the same day.
dateStr = datestr(now,'yymmdd_HHMMSS'); 
subNumStr=int2strz(subNum,2);
runNumberStr = int2strz(runNumber,2);

% Coding question 2:
% Removed dateStr from taskMapFile naming so the same taskmap
% filename is used for a given subject/session/run. This allows
% MATLAB to detect an existing taskmap and gives the experimenter
% the option to overwrite it.
datafile = [RESULTS_DIR currentStudy num2str(currentStudyVersion) subNumStr  num2str(session) '_' runNumberStr '_' dateStr '.csv'];
matfile = [RESULTS_DIR currentStudy num2str(currentStudyVersion) subNumStr  num2str(session) '_' runNumberStr '_' dateStr '.mat'];
taskMapFile = [TASK_MAPS currentStudy num2str(currentStudyVersion) subNumStr  num2str(session) '_' runNumberStr '_' dateStr '_taskMap.mat'];
logFile = [LOG_DIR currentStudy num2str(currentStudyVersion) subNumStr  num2str(session) '_' runNumberStr '_' dateStr '_log.txt'];

datafile = datafile;
matfile = matfile;
taskMapFile = taskMapFile;
logFile = logFile;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Hide Mouse Cursor
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if hideCursor
    HideCursor()
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Initialize screen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   To make it transparent for working in demo mode
if isDemoMode
    PsychDebugWindowConfiguration(0, transparency);
end
% degree of VA to pixel calculation

%STANDARD SCREEN SIZES
%Mac 27" ThunderBolt Display = [33.5, 59.6]
%Eyetracking Display = [28.7, 51.2]

format short
viewDist = viewDistance;
mainText = sprintf('Is the Viewing Distance -- %0.1fcm (Yes = 1, No = 0)  ',viewDist); 
viewDist = checkCorrectInput(mainText, 'Please enter either  0 or  1: ', [0,1]);

if viewDist == 0
    viewDist = input('Please enter the Vieweing Distance in CM:  ','s'); 
    viewDist  = str2num(viewDist);
    while isempty(viewDist)
        disp('A numeric value is expected.');
        viewDist = input('Please enter the Vieweing Distance in CM:  ','s'); 
        viewDist  = str2num(viewDist);
    end

elseif viewDist == 1

      viewDist = 60;

end

% Coding Challenge question 2:
% Check whether taskmap exists before opening PTB screen
if exist(taskMapFile,'file')
    overwrite = input('Taskmap already exists. Overwrite? (y/n): ','s');

   if strcmpi(overwrite,'y')
    generateTaskMap(taskMapFile,numberOfTrials);
  end
else
    generateTaskMap(taskMapFile,numberOfTrials);
end

taskMapStruct = load(taskMapFile);
taskMap = taskMapStruct.taskMap;


screenNumber = max(Screen('Screens')); %get the screen 

[screenXpixels, screenYpixels] = Screen('WindowSize', screenNumber); %get x and y pixels of screen
[screenWidth, screenHeight] = Screen('DisplaySize',screenNumber); %get screen width and height in mm

screenWidth = screenWidth/10; %mm to cm
screenHeight = screenHeight/10; %mm to cm


Hperdegree = viewDist * tan(deg2rad(1)); %height for one degree in cm
Wperdegree = Hperdegree; %width for one degree in cm

pixWidth = screenWidth/screenXpixels; %cm/pixel
pixHeight = screenHeight/screenYpixels; %cm/pixel
deg_width = atand(screenWidth/2 / viewDist) * 2;
deg_height = atand(screenHeight/2 / viewDist) * 2;

% screen init for PC and MAC
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white*0.5;
AssertOpenGL;
% Set blend function for alpha blending

[win, screenRect] = PsychImaging('OpenWindow', screenNumber,grey, [], 32, 2, [], [], kPsychNeed32BPCFloat);
ifi = Screen('GetFlipInterval', win);

% Retreive the maximum priority number
topPriorityLevel = MaxPriority(win);
Screen('BlendFunction', win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
pixels_per_deg_width = screenXpixels/deg_width; 
pixels_per_deg_height = screenYpixels/deg_height; 


xCenter = screenXpixels/2;
yCenter = screenYpixels/2;  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Convert values from visual degrees to pixels
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fixationCrossSizePix =fixationCrossSizeDeg * pixels_per_deg_width; 
rhoCirclePix = rhoCircleDeg * pixels_per_deg_width;
textSize = round(textSizeDeg * pixels_per_deg_width);
lineWidthPix = lineWidthDeg * pixels_per_deg_width; 
triangHeight = triangHeightDeg * pixels_per_deg_width;
triangWidth = triangWidthDeg * pixels_per_deg_width;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Initialize input devices
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LoadPsychHID;
    
%   create keyboard events queue
PsychHID('KbQueueCreate');

PsychHID('KbQueueStart');
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Generate task map
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%generateTaskMap(taskMapFile,numberOfTrials); 

%taskMapStruct = load(taskMapFile);
%taskMap = taskMapStruct.taskMap;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Fix the time when experiment starts
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
startTime = GetSecs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Run the experiment
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% To suspend the output of keyboard to command line
ListenChar(2); 


    
%  init structure to store user responces
%--------------------------------------------------------------------------------------------------------------------------------------%
% 
resReport = {};
row = 1;
for trials = 1:numberOfTrials
    clear map
    map = struct('trial',0,...
        'actualOrientation',0,...
        'reportedOrientation',0,...
        'error',0,...
        'score',0,...
        'responseTime',0);
    resReport{row}=map;
    row = row+1;
end

resReport=cell2mat(resReport);

totalScore = 0;

%import the files contating fixation crosses
fixCrossData=imread(strcat(pwd,'/supportFiles/fix1.png'),'BackgroundColor',[grey/255,grey/255,grey/255]);


%  init start of experiment procedures 
%--------------------------------------------------------------------------------------------------------------------------------------%
% 

text = welcomeMsg;

FlushEvents;
Screen('TextSize', win, textSize);
DrawFormattedText(win, text, 'center', 'center',white);
Screen('Flip', win);
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
    
  

%  iterate over all trials 
%--------------------------------------------------------------------------
% 
for   tc = 1:numberOfTrials
    
    % pre-trial window
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %import the files for the fixation crosses and create the respective textures
    fixBG = [grey grey grey]; %grey background offset
    
    %import the files contating the fixation crosses
    fix1Data=imread(strcat(pwd,'/supportFiles/fix1.png'),'BackgroundColor',fixBG./255); %Trial fixation
    % make texture image out of image matrix 'imdata'
    fix1=Screen('MakeTexture', win, fix1Data);
    
    fixRect = [ xCenter-fixationCrossSizePix ...
                yCenter-fixationCrossSizePix ...
                xCenter+fixationCrossSizePix ...
                yCenter+fixationCrossSizePix];

    Screen('DrawTexture', win, fix1,[],fixRect); %fixaton dot
    Screen('Flip', win);
    WaitSecs(preTrialTaskDuration);
    
    
    % sample window
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Screen('DrawTexture', win, fix1,[],fixRect); %fixaton dot
    
    %define the centers of triangles
    triangCenterX = screenXpixels/2; % triangle
    triangCenterY = yCenter;
    
    %define stimulus triangles
    StimulusTriangle= Triangle(taskMap(:,tc).triangOrientation,triangCenterX,yCenter,triangHeight,triangWidth);
    
    %draw left and right triangles on the screen
    Screen(win,'FillPoly',black, StimulusTriangle.setTriangleVertices())
    
    Screen('Flip', win);
    WaitSecs(sampleDuration);
    
    
    % delay window
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Screen('DrawTexture', win, fix1,[],fixRect); %fixaton dot
    Screen('Flip', win);
    WaitSecs(delayTaskDuration);
    
    
    % probe window
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % rectangle defining the central circle
    baseRect = [0 0 2*(rhoCirclePix) 2*(rhoCirclePix)];
    
    
    % Center the left hand side squares on positions in the 
    rect = CenterRectOnPointd(baseRect, xCenter, yCenter);
    
   
    % initialize clicking flag for responses
    mouseClicked = 0; 
    
    % for the first trial set the mouse coordinates in a random place of the screen
    SetMouse(randi(screenXpixels),randi(screenYpixels),win); 
    
    % Coding Challenge Question 3:
    % Randomly initialize the probe triangle orientation and ensure
    % it differs from the stimulus orientation by at least 30 degrees.

    triangCenterX = xCenter;
    triangCenterY = yCenter;

    stimTheta = taskMap(:,tc).triangOrientation;

    initTheta = randi(360);

    angleDiff = min(abs(initTheta - stimTheta), ...
                360 - abs(initTheta - stimTheta));

    while angleDiff < 30
       initTheta = randi(360);

       angleDiff = min(abs(initTheta - stimTheta), ...
                360 - abs(initTheta - stimTheta));
    end

   currentTriangle = Triangle(initTheta,...
                           xCenter,...
                           yCenter,...
                           triangHeight,...
                           triangWidth);

    % Verified using temporary disp statements that the minimum angular
    % difference between the stimulus and probe orientations was >= 30 degrees.

    %disp(['Stimulus: ' num2str(stimTheta)])
    %disp(['Probe: ' num2str(initTheta)])
    %disp(['Difference: ' num2str(angleDiff)])
  
    tempCoord =currentTriangle.setTriangleVertices();
    initTriangVerticeCoord = [tempCoord(1,1),tempCoord(1,2)];    
  
    %   draw an intital triangle in the center (alpha = 0, rho = triangHeight/2)
    %----------------------------------------------------------------------
    triangCenterX = xCenter;
    triangCenterY = yCenter;
    currentTriangle = Triangle(initTheta,xCenter,yCenter,...
                          triangHeight,triangWidth);

    thetaDeg = initTheta;

% draw circle
Screen('FillOval', win, grey, rect);
Screen('FrameOval', win, white, rect, 3);

% draw initial probe triangle
Screen(win,'FillPoly',white,currentTriangle.setTriangleVertices());

    Screen('Flip', win);

    % Wait for mouse click reset
    while sum(mouseClicked)~=0
        [xmouse,ymouse,mouseClicked] = GetMouse;
    end

    %   monitor mouse clicks
    %----------------------------------------------------------------------
    %  

    %   initialize flag for clicking 
    mouseClicked = 0;

    %   initialize the starting time of the current bet 
    timeStart = GetSecs;

    while (any(mouseClicked) ==0)
     [xmouse,ymouse,mouseClicked] = GetMouse(win);

     % Coding Challenge Question 6:
% Allow experimenter to quit at any time using the Q key.


     [keyIsDown,~,keyCode] = KbCheck;

    if keyIsDown && keyCode(KbName('q'))

     save(matfile,'resReport');
     writetable(struct2table(resReport),datafile);

     sca;
     ListenChar(0);
     ShowCursor;

    return;

  end

% initialize the end time
timeEnd = GetSecs;

% convert mouse coordinates into polar
[alpha, rho] = cart2pol(xmouse-triangCenterX,...
                        ymouse-triangCenterY);

% adjust the angle
if rad2deg(alpha)>=0 && rad2deg(alpha)<=180
    thetaDeg = 90+rad2deg(alpha);
elseif rad2deg(alpha)<0 && rad2deg(alpha)>=-90
    thetaDeg = 90+rad2deg(alpha);
elseif rad2deg(alpha)<-90 && rad2deg(alpha)>-180
    thetaDeg = 360+(rad2deg(alpha)+90);
end
        
        %  initialize the end time 
        timeEnd = GetSecs;
        
        % convert mouse coordinates into polar
        [alpha, rho] = cart2pol(xmouse-triangCenterX,ymouse-triangCenterY);

        % adjust the angle to the scale starting with 0 at 90 degrees
        % and positive in clockwise  direction
        if rad2deg(alpha)>=0 && rad2deg(alpha) <=180
            thetaDeg = 90+rad2deg(alpha);
        elseif rad2deg(alpha)<0 && rad2deg(alpha) >=-90
            thetaDeg = 90+rad2deg(alpha);
        elseif rad2deg(alpha)<-90 && rad2deg(alpha) >-180
            thetaDeg =360+(rad2deg(alpha)+90);
        end

        %fill the main circle
        Screen('FillOval', win, grey, rect);
        %draw the main circle
        Screen('FrameOval', win, white, rect, 3);
        %rotate the triangle
        currentTriangle.rotationAngle = thetaDeg;

        % draw probe triangle following the mouse pointer
        Screen(win,'FillPoly',white, currentTriangle.setTriangleVertices());

        % to determine the response error we also need the vertix of
        % the rotated triangle
        tempCoord =currentTriangle.setTriangleVertices();
        currentTriangVerticeCoord = [tempCoord(1,1),tempCoord(1,2)]; 

        % let's define two vectors starting from the center of the
        % screen and ending in the vertices of initial triangle and the
        % reported triangle. The angle btw these two vectors will give
        % us the response error (in degrees). It is positive in clock-
        % wise and negative in counterclockwise directions
        v1 = [initTriangVerticeCoord(1)-triangCenterX,initTriangVerticeCoord(2)-triangCenterY];
        v2 = [currentTriangVerticeCoord(1)-triangCenterX,currentTriangVerticeCoord(2)-triangCenterY];

        %  Dividing these vectors' cross product's length by their dot 
        %  product gives the angle in degrees between the vectors as 
        %  measured in a counterclockwise direction from v1 to v2. If 
        %  that angle would exceed 180 degrees, then the angle is measured
        %  in the clockwise direction but given a negative value gives 
        %  the angle in degrees between the vectors as measured in a 
        %  counterclockwise direction from v1 to v2. If that angle would 
        %  exceed 180 degrees, then the angle is measured in the clockwise 
        %  direction but given a negative value.
        %  https://www.mathworks.com/matlabcentral/answers/180131-how-can-i-find-the-angle-between-two-vectors-including-directional-information
      respError = thetaDeg - taskMap(:,tc).triangOrientation;

      % Wrap error to range -180 to 180
      respError = mod(respError + 180, 360) - 180;
 
      Screen('Flip', win);
    end


    %record results
    %----------------------------------------------------------------------
    % 
    
    timeElapsed = timeEnd-timeStart;

    resReport(:,tc).trial = tc;

    resReport(:,tc).actualOrientation =  taskMap(:,tc).triangOrientation ;
    resReport(:,tc).reportedOrientation = thetaDeg;
    resReport(:,tc).error = respError;
    resReport(:,tc).responseTime = timeElapsed;
    disp(['Actual: ' num2str(taskMap(:,tc).triangOrientation)])
    disp(['Reported: ' num2str(thetaDeg)])
    disp(['Error: ' num2str(respError)])
    respError = thetaDeg - taskMap(:,tc).triangOrientation;
    respError = mod(respError + 180, 360) - 180;
    resReport(:,tc).error = respError;
    scoreEarned = round(max(0,100*(1-abs(respError)/180)));
    resReport(:,tc).score = scoreEarned;
    totalScore = totalScore + scoreEarned;
    
    
    
    % feedback window
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Your code for subject feedback goes here, but you have to do it with
    % a function! The feedback function should be called:
    % showFeedbackWindow.m


showFeedbackWindow(win,...
                  scoreEarned,...
                  totalScore,...
                  thetaDeg,...
                  taskMap(:,tc).triangOrientation,...
                  xCenter,...
                  yCenter,...
                  triangHeight,...
                  triangWidth);

WaitSecs(feedBackTime);
    
  

% Coding Challenge Question 4:
% Display a break screen at the end of each block and wait for
% the participant to press Space before continuing.

if mod(tc,trialsPerBlock) == 0 && tc < numberOfTrials

    blockNumber = tc/trialsPerBlock;

    DrawFormattedText(win,...
        ['End of Block ' num2str(blockNumber) ...
        '. Press Space to Continue'],...
        'center','center',black);

    Screen('Flip',win);

    while 1
        [keyIsDown,~,keyCode] = KbCheck;

        if keyIsDown && keyCode(KbName('space'))
            break;
        end
    end

    KbReleaseWait;
end

end

%  init end of experiment procedures
%--------------------------------------------------------------------------------------------------------------------------------------%
% 

eoeMsg = sprintf('%s \nYour cummulative score is %.2f.\n', thankYouMsg, totalScore);
    
showEoeWindow(white, eoeMsg, textSize, win);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Save the data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
totalTime = GetSecs-startTime;
writetable(struct2table(resReport),datafile);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Save the taskmap if modified
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save(taskMapFile,'taskMap');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Save log file
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
logData = fopen(logFile,'wt');

%save results to file
%--------------------------------------------------------------------------------------------------------------------------------------%
fprintf(logData, sprintf('%-50s%-10s\n','Date', date));
fprintf(logData, sprintf('%-50s%-10.2f%-10s\n','Time taken', totalTime,'sec'));
fprintf(logData, sprintf('%-50s%-10s\n','Study', currentStudy));
fprintf(logData, sprintf('%-50s%-10d\n','Version',currentStudyVersion));
fprintf(logData, sprintf('%-50s%-10d\n','Run',runNumber));
fprintf(logData, sprintf('%-50s%-10d\n','Session',session));
fprintf(logData, sprintf('%-50s%-10d\n','Subject id',subjectId));
fprintf(logData, sprintf('%-50s%-10d\n','Number of trials',numberOfTrials));
fprintf(logData, sprintf('%-50s%-10.2f\n','Sample duration', sampleDuration));

fprintf(logData, sprintf('%-50s%-10s\n','Points earned', totalScore));

fprintf(logData, sprintf('%-50s%-10.5f\n','ifi', ifi));
fprintf(logData, sprintf('%-50s%-10d\n','x pixels', screenXpixels));
fprintf(logData, sprintf('%-50s%-10d\n','y pixels', screenYpixels));
fprintf(logData, sprintf('%-50s%-10.2f%-10s\n','Screen width', screenWidth, 'cm'));
fprintf(logData, sprintf('%-50s%-10.2f%-10s\n','Screen height', screenHeight, 'cm'));
fprintf(logData, sprintf('%-50s%-10.2f%-10s\n','Viewing distance', viewDist, 'cm'));

fprintf(logData, sprintf('%-50s%-10.2f\n','Delay duration', delayTaskDuration));
fprintf(logData, sprintf('%-50s%-10.2f\n','Feedback duration', feedBackTime));
fprintf(logData, sprintf('%-50s%-10.2f\n','Grey factor', greyFactor));

fprintf(logData, sprintf('%-50s%-10.2f%-10s\n','Fixation dot size', fixationCrossSizePix, 'px'));
fprintf(logData, sprintf('%-50s%-10.2f%-10s\n','Fixation dot size', fixationCrossSizeDeg, 'deg'));

fprintf(logData, sprintf('%-50s%-10.2f%-10s\n','Radius of the central circle', rhoCirclePix, 'px'));
fprintf(logData, sprintf('%-50s%-10.2f%-10s\n','Radius of the central circle', rhoCircleDeg,'deg'));

fclose('all');

   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Clear the keyboard buffer
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FlushEvents;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   To allow the output of keyboard to command line
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
ListenChar(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Show cursor back
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
ShowCursor('Arrow');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Screev Clean All (sca)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sca;

