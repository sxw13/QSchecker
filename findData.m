%��ѯ�������������ݣ�����λ���б�
function index = findData(table,propName,value)
    index=[];
    for id = 2:length(table)
        result = getProperty(table,id,propName);
        if strcmp(result,value)
            index = [index id];
            break;
        end
    end
end