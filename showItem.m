clc;
qsData = readQSFile('QSdata\20140714_0455.QS');
Transformer = qsData('Transformer');
id = 559;

item = Transformer(num2str(id));

for idd = keys(item)
    disp([idd{1} ' : ' item(idd{1})]);
end