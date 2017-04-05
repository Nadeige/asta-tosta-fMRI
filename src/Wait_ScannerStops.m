        
function time = Wait_ScannerStops(SerPor, TimeOutMilliSeconds, varargin)

if nargin==2 || isempty(varargin{1})
    TR = GetSecs;
else
    TR = varargin{1};
end

    fprintf (1,'Waiting for scanner to stop\n');
    pulseflag = 0;
    tStart = GetSecs;
    lasttime = GetSecs;
    while (GetSecs - lasttime)<2*TR
        if SerPor.BytesAvailable
            % read the buffer of the serial port
            sbuttons = str2num(fscanf(SerPor,'%c',1));  
            
            % check if it is a RM trigger
            if sbuttons == 5  
                pulseflag=pulseflag+1;
                time(pulseflag) = GetSecs;
                lasttime = time(pulseflag);
                fprintf (1,'%d\n', pulseflag)
            end
        else    
            if (GetSecs - tStart) > TimeOutMilliSeconds/1000
                fprintf (1,'%s\n', 'Return for TIMEOUT!!!')
                return;
            end
        end
    end
end
