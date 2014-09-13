function y = getProperty_Value(table,id,propName)
    dataitem = table(id);
    y = str2double(dataitem(propName));
end