%进行数据预查询
function indexMap = startFind(table,propName)
    indexMap = containers.Map;
    for idcon = keys(table)
        id = idcon{1};
        thisitem = table(id);
        propValue = thisitem(propName);
        if isKey(indexMap,propValue)
            index = indexMap(propValue);
            index{length(index)+1} = id;
            indexMap(propValue) = index;
        else
            indexMap(propValue)={id};
        end
    end
end