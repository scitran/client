function [jx,jy, f,fig] = stPlotJitter(x,y,f,fig,pSymbol)
%Plot points with a little added noise to show multiple repeats
%
% Syntax:
%     [jx,jy,f,fig]   = stPlotJitter(x,y,[f],[fig],[pSymbol])
%
% Inputs
%  x,y     Lists of points
%  f:      Random jitter amount.  Default is 1/200 of the larger range.
%  fig:    Which figure - use fig<0 to suppress plotting
%  pSymbol Plotting symbol
%
% Outputs
%  jx,jy:  Jittered xy values used for plotting
%          These can also be retrieved by u = get(gca,'userdata');
%  f       Jitter fraction used
%  fig
%
% Wandell
%
% See also:
%    stHistImage, stNewGraphWin

% Examples:
%{
  x = [100*ones(10,1); 200*ones(10,1)]; y = x;
  stPlotJitter(x,y,5,[],'rx'); grid on
%}  

%%
if notDefined('f')
    f(1) = range(x)/200; f(2) = range(y)/200;
end
if notDefined('fig'),     fig = stNewGraphWin; end
if notDefined('pSymbol'), pSymbol = '.k'; end

%% Make the randomly perturned points    
N = length(x);
jx = x(:) + rand(N,1)*f(1);
jy = y(:) + rand(N,1)*f(2);

% Plot them as dots.  I guess the symbols should be a parameter
figure(fig)    
plot(jx,jy,pSymbol)

% Store them and return
pts.jx = jx; pts.jy = jy;
set(gca,'userdata',pts);

end
