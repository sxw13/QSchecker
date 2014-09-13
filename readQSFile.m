%将QS文件解析到结构体
function result = readQSFile(path)
    %读取QS文件
    result = containers.Map;
    fid = fopen(path,'r');
    tag = 'none';
    datacount = 2;
    while ~feof(fid)
        thisline = fgetl(fid);
        if length(thisline)<2 continue;end
        switch thisline(1)
            case '<'
                if thisline(2)~='/' && thisline(2)~='!'
                    idx = strfind(thisline,':');
                    if ~isempty(idx)
                        tag = thisline(2:idx(1)-1);
                    else
                        tag = thisline;
                    end
                    datacount = 2;
                    thistable = cell(1);
                elseif thisline(2)=='/'
                    result(tag) = thistable;
                end
            case '@'
                thistable = containers.Map;
                propNames = regexp(thisline, '\s+', 'split');
            case '#'
                thisitem = containers.Map;
                propValues = regexp(thisline, '\s+', 'split');
                datacount = datacount + 1;
                for id = 2:length(propValues)
                    thisitem(propNames{id}) = propValues{id};
                end
                thistable(propValues{2}) = thisitem;
        end
    end
    fclose(fid);
end