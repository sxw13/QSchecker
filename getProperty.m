%获得QS文件中某个Tag下的属性
%id是字符串
function y = getProperty(table,id,propName)
    dataitem = table(id);
    y = dataitem(propName);
end