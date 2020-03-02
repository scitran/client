function newTable = dr_mergeTables(tables,keysToMerge)
%DR_MERGE_TABLES Merges tables by ensuring that nested tables all have
% matching keys.


% keysToMerge = {
%     'SubjectMD';
%     'AcquMD';
%     'AnalysisMD';
% };

% We assume the tables have the same keys. So it is safe to simply grab
% values from the first table.
noMergeKeys = setdiff(tables{1}.Properties.VariableNames, keysToMerge);

% We merge the input tables, skipping the keys that need merging.
newTable = [];
for tableIdx=1:length(tables)
    filtered = tables{tableIdx}(:, noMergeKeys);
    if isempty(newTable)
        newTable = filtered;
    else
        newTable = [newTable;filtered];
    end
end

for idx=1:length(keysToMerge)
    key = char(keysToMerge(idx));

    % We look for common keys across the tables
    commonKeys = tables{1}.(key).Properties.VariableNames;
    for tableIdx=2:length(tables)
        commonKeys = intersect(commonKeys, tables{tableIdx}.(key).Properties.VariableNames);
    end

    % We filter and stack the tables
    % HACK should consider doing something like:
    % outerjoin(merged, tables{tableIdx}.(key), 'LeftVariables', commonKeys, 'RightVariables', commonKeys, 'MergeKeys', true)
    merged = [];
    rowCount = 0;
    for tableIdx=1:length(tables)
        switch key
            case {'SubjectMD'}
                % For subject metadata, we only return common keys.
                filtered = tables{tableIdx}.(key)(:, commonKeys);
                if isempty(merged)
                    merged = filtered;
                else
                    merged = dr_mergeTables({merged,filtered},{'info'});
                end
            case {'AcquMD','AnalysisMD','info'}
                % For all other metadata, we return all keys, letting outerjoin
                % fill in missing variables.
                keyTable = tables{tableIdx}.(key);
                keyTable.rowidx__ = (rowCount + (1:height(keyTable)))';
                if isempty(merged)
                    merged = keyTable;
                else
                    % Since we are merging simple tables, this should work
                    % well. If this routine ever needs to merge more complex
                    % tables, this will need to be made more robust.
                    % We use outerjoin because it can easily handle missing columns
                    % from other tables, regardless of their type.
                    oldMerged = merged;
                    [merged, iA, iB] = outerjoin(merged, keyTable, 'MergeKeys', true);
                    if height(merged) ~= height(oldMerged) + height(keyTable)
                        error('Error while merging in table %d: some rows were missing from merge.', tableIdx);
                    end
                    % HACK since outerjoin doesn't maintain order of inputs,
                    % we have to reconstruct the inputs and merge them below.
                    idxAToMerged = NaN(height(oldMerged), 1);
                    idxBToMerged = NaN(height(keyTable), 1);
                    for mergedIdx=1:height(merged)
                        if iA(mergedIdx) && iB(mergedIdx)
                            error('Error. Row %d in merged output is shared with both inputs.', mergedIdx);
                        end
                        if iA(mergedIdx)
                            idxAToMerged(iA(mergedIdx)) = mergedIdx;
                        end
                        if iB(mergedIdx)
                            idxBToMerged(iB(mergedIdx)) = mergedIdx;
                        end
                    end
                    merged = [merged(idxAToMerged, :) ; merged(idxBToMerged, :)];
                end

            % HACK counting rows to make sure outerjoin doesn't drop any.
            rowCount = rowCount + height(keyTable);
        end
    end

    % HACK we verify that no rows were dropped by outerjoin since it
    % might if the rows aren't unique. In general though, we expect rows to
    % be unique.
    if ~strcmp(key, 'SubjectMD')
        if rowCount ~= height(merged)
            error('Rows across tables were not unique for key %s. Expected %d rows, but found %d in merged table.', key, rowCount, height(merged));
        end
        % HACK we remove the rowidx__ column
        merged = merged(:, setdiff(merged.Properties.VariableNames, {'rowidx__'}));
    end

    % And add the slim and merged tables to our result.
    newTable.(key) = merged;
end

end
