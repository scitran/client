function curENV = configure_curl()
% Configure library paths for curl to work properly on MAC or Linux
%
%  We need to be able to save the appropriate environment and restore it
%  later.  I started to hack on this to make that happen, but it is not yet
%  done.  Will start an issue.
%
% LMP Vistasoft Team, 2016

% Check system and set up library
if ismac
    % Get rid of this library on OSX.
    curENV = getenv('DYLD_LIBRARY_PATH');
    if isempty(curENV), return;
    else setenv('DYLD_LIBRARY_PATH','');
    end
elseif (isunix && ~ismac)   % Linux
    % Set the proper order needed by curl on Linux.
    % What if there are other directories on the path?
    curENV = getenv('LD_LIBRARY_PATH');
    k1 = strfind(curENV,'/usr/lib');
    k2 = strfind(curENV,'/usr/local/lib');
    if k2 < k1
        warning('Library ordering');
    end
    
    % I guess we can just over-write, but perhaps we should adjust?
    p = explor(':',curENV);
    fprintf('Load library path %s\n',p);
    setenv('LD_LIBRARY_PATH','/usr/lib:/usr/local/lib');
else
    % Other/Unknown
    error('Unsupported system.\n');
end

end
