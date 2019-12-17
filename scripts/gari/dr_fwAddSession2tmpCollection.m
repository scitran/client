function dr_fwAddSession2tmpCollection(st, thisSession, collection)
    % Use the same function to obtain the tmpCollection
    % Use the name, if this code is being used in another server, better than using
    % the ID. We just want the collectionID in this case, check outputs in the same
    % function
    
    if ~exist(collection)
        collection = 'tmpCollection';
    end
    
    CollectionID = '';
    collections  = st.fw.getAllCollections();
    for nc=1:length(collections)
        if strcmp(collections{nc}.label, collection)
            CollectionID = collections{nc}.id;
        end
    end

    if isempty(CollectionID)
        error(fprintf('Collection %s could not be found on the server %s (verify permissions or the collection name). TODO FC: addCollection(servername). \n', collectionName, serverName))
    else
        tmpCollection = st.fw.getCollection(CollectionID);
    end



    % Add session to collection
    % st.fw.addSessionsToCollection(tmpCollectionID, idGet(thisSession])
    % Justin explained that the previous function is not
    % working, he propossed this temporary fix
    nodes = {flywheel.model.CollectionNode('level', 'session', 'id', idGet(thisSession)) };
    contents = flywheel.model.CollectionOperation('operation', 'add', 'nodes', nodes);
    st.fw.modifyCollection(idGet(tmpCollection), flywheel.model.Collection('contents', contents));            
    fprintf('   ... session added to %s \n', collection) 
end