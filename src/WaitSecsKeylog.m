function [keyCode, pressTime] = WaitSecsKeylog(timeout, mode, varargin)

keyCode = {};
pressTime = NaN;
k=0;

if nargin==2 || isempty(varargin{1})
    startime = GetSecs;
else
    startime = varargin{1};
end

switch mode
    case {'behav','behavior', 'mriSimulator'}
        KbQueueCreate;
        KbQueueStart;

        while ((GetSecs - startime) < timeout) % wait for press
            % Do some other computations, display things on screen, play sounds, etc
            [ pressed, firstPress]=KbQueueCheck; % Collect keyboard events since KbQueueStart was invoked
            if pressed
                k = k+1;
                pressedCodes=find(firstPress);
                for i=1:size(pressedCodes,2)
                    keyCode{k,i} = KbName(pressedCodes(i));
                    pressTime(k,i) = firstPress(pressedCodes(i));
                end
            end
        end
        KbQueueRelease;
        
    case {'mriScanner', 'mriSimulator_serial'}
        SerPor = varargin{2};
        while ((GetSecs - startime) < timeout) % wait for press
            if (SerPor.BytesAvailable)
                sbutton = str2num(fscanf(SerPor,'%c',1));  % read serial buffer
                disp(sbutton);
                k = k+1;
                keyCode{k} = sbutton;   
                pressTime(k) = GetSecs;
            end
        end      
end