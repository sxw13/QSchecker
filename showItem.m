clc;
qsData = readQSFile('QSdata\20140714_0455.QS');
Transformer = qsData.Transformer;
id = 560;

titleline = Transformer{1};
dataline = Transformer{id};
title = regexp(titleline, '\s+', 'split');
data = regexp(dataline, '\s+', 'split');

for idd = 2:length(title)
    disp([title{idd} ' : ' data{idd}]);
end