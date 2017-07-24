%%This script will play a movie with an overlayed checkboard.
AssertOpenGL;
PsychDefaultSetup(2);  
AssertOpenGL;
%Undo Warnings
%
oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);
oldSkipSyncTests = Screen('Preference', 'SkipSyncTests', 2);


moviename = [ '/home/gsteelman/Desktop/Summer Research/Media/innocuous.mp4' ];
moviename2 = [ '/home/gsteelman/Desktop/Summer Research/Media/dot.mp4' ];
Hz = 1.9*2 ;
time = 200;
transparencyChecker = 100 ;

  
windowrect = [];


% Wait until user releases keys on keyboard:
KbReleaseWait;

% Select screen for display of movie:
screenid = max(Screen('Screens'));

try
    % Open 'windowrect' sized window on screen, with black [0] background color:
    [window, windowRect] = Screen('OpenWindow', screenid, 0 );
    
    
    
    
    
    checkerboard = repmat(eye(2), 3, 3,4);
    checkerboard = checkerboard .* 255;

    checkerboard2 = abs(255-checkerboard);
    
    checkerboard(:,:,4) = zeros(6,6) +transparencyChecker; 
    checkerboard2(:,:,4) = zeros(6,6) +transparencyChecker; 

    % Make the checkerboard into a texure (4 x 4 pixels)
    checkerTexture(1) = Screen('MakeTexture', window, checkerboard);
    checkerTexture(2) = Screen('MakeTexture', window, checkerboard2 );

    
    % Open movie file:
    movie = Screen('OpenMovie', window, moviename);
    movie2 = Screen('OpenMovie', window, moviename2);
    
    % Start playback engine:
    
    
    
   
    % Query the frame duration
    ifi = Screen('GetFlipInterval', window);
    slack = ifi/2;
    checkFlipTimeSecs = 1/Hz;
    checkFlipTimeFrames = round(checkFlipTimeSecs / ifi);

    % Get the centre coordinate of the window
    [xCenter, yCenter] = RectCenter(windowRect);
    [wW,wH] = Screen('WindowSize', window)

    % Set up alpha-blending for smooth (anti-aliased) lines
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    % Define a simple 4 by 4 checker boar

    % We will scale our texure up to 90 times its current size be defining a
    % larger screen destination rectangle
    [s1, s2] = size(checkerboard);
    dstRect = [0 0 s1 s2] .*  20;
    dstRect = [0 0 wW*.75 wH*.75 ]; 
    dstRect = CenterRectOnPointd(dstRect, xCenter, yCenter);

    % Draw the checkerboard texture to the screen. By default bilinear
    % filtering is used. For this example we don't want that, we want nearest
    % neighbour so we change the filter mode to zero
    filterMode = 0;

    % Time to wait in frames for a flip
    waitframes = 1;

    % Texture cue that determines which texture we will show
    textureCue = [1 2];
    first = 1
    % Sync us to the vertical retrace
    topPriorityLevel = MaxPriority(window);
    Priority(topPriorityLevel);
    vbl = Screen('Flip', window);
    tic
    t = toc;
    numTimes = Hz * time;
    p = 0;
    frameCounter = 0;
    Screen('PlayMovie', movie2, 1);
    tex = Screen('GetMovieImage', window, movie2,1,0); 
    while p<numTimes  && ~KbCheck

            % Increment the counter
            frameCounter = frameCounter + waitframes;
            
            if first
                
                tex = Screen('GetMovieImage', window, movie2,0,0);
                
                
            else
                
                tex = Screen('GetMovieImage', window, movie,0,0);
                
                
            end
            
            
            if toc > 10 && first
                first = 0; 
                Screen('PlayMovie', movie2, 0);
    
                % Close movie:
                Screen('CloseMovie', movie2);
    
                Screen('PlayMovie', movie, 1);
                
                
            end
            
            if tex>0
            % We're done, break out of loop 

                Screen('DrawTexture', window, tex,[],dstRect );
            end

            % Draw our texture to the screen
            Screen('DrawTexture', window, checkerTexture(textureCue(1)),[],dstRect, 0, filterMode);

            % Flip to the screen 
            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);


            % Reverse the texture cue to show the other polarity if the time is up
            if frameCounter >= checkFlipTimeFrames
                p = p+1;
                toc - t
                t = toc;
                textureCue = fliplr(textureCue);
                frameCounter = 0;
            end

    end
     
    
    % Stop playback:
    Screen('PlayMovie', movie, 0);
    
    % Close movie:
    Screen('CloseMovie', movie);
    
    % Close Screen, we're done:
    sca;
    
catch %#ok<CTCH>
    sca;
    psychrethrow(psychlasterror);
end
KbStrokeWait;
sca;