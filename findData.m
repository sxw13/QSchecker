%��ѯ�������������ݣ�����λ���б�
function index = findData(table,propName,value)
    index = cell(0);
    for idcon = keys(table)
        id = idcon{1};
        result = getProperty(table,id,propName);
        if strcmp(result,value)
            index{length(index)+1} = id;
        end
    end
end