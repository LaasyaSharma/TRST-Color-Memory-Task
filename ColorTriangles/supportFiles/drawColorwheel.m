global screen;

%   Initialize screen
initScreen(); 

grey  = screen.grey;
% load our colorwhel data
load colorwheel360;
colormatrix = fullcolormatrix;

% get coordinates of the screen center
xCenter = screen.screenXpixels/2;
yCenter = screen.screenYpixels/2;

%wheel parameters
wheelOuterRingRadiusDVA = 6.5; %radius of outer ring of color wheel in DVA
wheelInnerRingRadiusDVA = 5.5; %radius of inner ring of color wheel in DVA

% convert DVA to Pix
wheelOuterRingRadiusPix = round(wheelOuterRingRadiusDVA * screen.pixels_per_deg_width); 
wheelOuterRingLoc = [[xCenter yCenter]-wheelOuterRingRadiusPix [xCenter yCenter]+wheelOuterRingRadiusPix];

wheelInnerRingRadiusPix = round(wheelInnerRingRadiusDVA * screen.pixels_per_deg_width); 
wheelInnerRingLoc = [[xCenter yCenter]-wheelInnerRingRadiusPix [xCenter yCenter]+wheelInnerRingRadiusPix];

arcRotate = 45; %how much the colorwheel arc will rotate

%draw the main circle
for j = 1:size(colormatrix,1) %go through the colormatrix and fill the arc with rows from the colormatrix at 2 degree intervals
    Screen('FillArc', screen.win, colormatrix(j,:), wheelOuterRingLoc, arcRotate+(j-1),1); %note this begins filling from 0 at vertical meridien)
end

%fill the main circle
Screen('FillOval', screen.win, grey, wheelInnerRingLoc);

% flip the screen to show colorwheel
Screen('Flip', screen.win);