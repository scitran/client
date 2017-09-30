function cmdout = testBridge(obj, s)
[status,cmdout] = system([obj.folder '/sdk TestBridge ' s]);
end