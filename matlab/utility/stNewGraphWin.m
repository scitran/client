function figHdl = stNewGraphWin(varargin)
% Open a window for plotting
%
%    figHdl = stNewGraphWin(varargin)
%
% A graph window figure handle is returned and stored in the currernt
% vcSESSION.GRAPHWIN entry.
%
% The varargin is a set of (param,val) pairs 
%
% A few figure shapes can be defaulted
%  format:
%           upper left    
%           tall          (for 2x1 stNewGraphWin)
%           wide          (for 1x2 stNewGraphWin)
%           upperleftbig  (for 2x2 stNewGraphWin)
%  position: [Rect], a custom format  (normalized screen coordinates)
%  visible: on or off
%  color:   RGB background color
%
% Examples
%  stNewGraphWin;
%
%  stNewGraphWin('format','upper left')   
%  stNewGraphWin('format','tall')
%  stNewGraphWin('format','wide')
%  stNewGraphWin('format','upper left big')
%
% Or set your own position
%  stNewGraphWin('position',[0.5 0.5 0.28 0.36]);
%
% To set other fields, use
%
%  stNewGraphWin('Color',[0.5 0.5 0.5])
%  g = stNewGraphWin('Visible','off'); pause(1); set(g,'Visible','on')
%
%

%% Parse
p = inputParser;

p.addParameter('figHdl',[],@isgraphics);
p.addParameter('format','upper left',@ischar);
p.addParameter('visible','on',@ischar);
p.addParameter('color',[1 1 1],@isvector);
p.addParameter('position',[0.007 0.55  0.28 0.36],@isvector);

p.parse(varargin{:});
figHdl  = p.Results.figHdl;
format  = p.Results.format;
color   = p.Results.color;
visible = p.Results.visible;
position = p.Results.position;

% Position the figure
format = stParamFormat(format);
switch(format)
    case 'upperleft'
        position = [0.007 0.55  0.28 0.36];
    case 'tall'
        position = [0.007 0.055 0.28 0.85];
    case 'wide'
        position = [0.007 0.62  0.60  0.3];
    case 'upperleftbig'
        % Like upperleft but bigger
        position = [0.007 0.40  0.40 0.50];
    otherwise % Default or user supplied
end

%% Apply settings

if isempty(figHdl), figHdl = figure; end

set(figHdl,'Name','Scitran GraphWin','NumberTitle','off');
set(figHdl,'Color',color);
set(figHdl,'Visible',visible);
set(figHdl,'Units','normalized','Position',position);

end
