function y = getProperty_Value(table,id,propName)
    titleline = table{1};
    temp = 0;
    sum = 0;
    for i = 1:length(id)
        fun = id(1,i);
        dataline = table{fun};        
        title = regexp(titleline, '\s+', 'split');
        data = regexp(dataline, '\s+', 'split');
        for idtitle = 1:length(title)
            if strcmp(propName,title{idtitle})
                temp = str2num(data{1,idtitle}); %temp = temp + data{idtitle};
                mid = sum;
                sum = mid + temp;
                mid = 0;
            end
        end
    end    
    y = sum;
end