function AFQ_FgToTck(fg, outPath, fib2mt)
    for fiberNum  = 1:length(fg)
        myfg      = fg(fiberNum); 
        fiberName = [strrep(myfg.name,' ','') '.tck'];
        % Usually tck files stored in mrtrix folder
        fiberPath = fileparts(outPath);
        if fib2mt;fiberPath = strrep(fiberPath,'fibers','mrtrix'); end
        if ~exist(fiberPath,'dir'); mkdir(fiberPath);end
        dr_fwWriteMrtrixTck(myfg, fullfile(fiberPath, fiberName))
    end
end





