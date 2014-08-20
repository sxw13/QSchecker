%将QS文件解析到结构体
function result = readQSFile(path)
    %读取QS文件
    result = struct();
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
                    if length(idx)>0
                        tag = thisline(2:idx(1)-1);
                    else
                        tag = thisline;
                    end
                    datacount = 2;
                    thistable = cell(1);
                elseif thisline(2)=='/'
                    result.(tag) = thistable;
                end
            case '@'
                thistable{1} = thisline;
            case '#'
                thistable{datacount} = thisline;
                datacount = datacount + 1;
        end
    end
    fclose(fid);
end