function containers = dr_fwSearchAcquAnalysis(st, session, containerType, pattern, allOrLast)
    % Create the empty container to check with isempty
    %{
    session       = thisSession;
    containerType = 'analysis';
    pattern       = 'b2000 mrtrix3preproc:1.0.2 analysis';
    preprocAnalysis2000 = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'b2000 mrtrix3preproc:1.0.2 analysis');
    %}
    containers = {};
    switch containerType
        case {'acquisition'}
            acqus = st.list('acquisition', idGet(session));
            ii = 0;
            for na=1:length(acqus)
                acqu = st.fw.getAcquisition(idGet(acqus{na}));
                if contains(strrep(acqu.label,' ',''),strrep(pattern,' ',''))
                    ii = ii + 1;
                    containers{ii} =  acqu;
                end
            end
        case {'analysis'}
            analyses = st.fw.getSessionAnalyses(session.id);
            ii = 0;
            for na=1:length(analyses)
                analysis = analyses{na};
                if contains(strrep(analysis.label,' ',''),strrep(pattern,' ',''))
                    ii = ii + 1;
                    containers{ii} = analysis;
                end
            end
        otherwise
            error(sprintf('This container type (%s) does not exist', containerType))
    end
    switch allOrLast
        case {'all'}
            % Do nothing for now, we will a cell array with all containers. 
        case {'last'}
            % Select the last one and return it as a container, not as a cell. 
            containers = containers{length(containers)};
        otherwise
            error('Only "all" and "last" are allowed for this variable.')
    end
    
end



