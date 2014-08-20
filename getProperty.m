%获得QS文件中某个Tag下的属性
function y = getProperty(table,id,propName)
    titleline = table{1};
    dataline = table{id};
    title = regexp(titleline, '\s+', 'split');
    data = regexp(dataline, '\s+', 'split');
    for id = 1:length(title)
        if strcmp(propName,title{id})
            y = data{id};
        end
    end
end