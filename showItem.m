clc;
qsData = readQSFile('QSdata\20140611_1200.QS');
Transformer = qsData.Unit;
id = 78;

titleline = Transformer{1};
dataline = Transformer{id};
title = regexp(titleline, '\s+', 'split');
data = regexp(dataline, '\s+', 'split');

for idd = 2:length(title)
    disp([title{idd} ' : ' data{idd}]);
end