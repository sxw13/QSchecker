clc;
qsData = readQSFile('QSdata\¸£½¨_20140714_0045.QS');
qsData2 = readQSFile('QSdata\¸£½¨_20140714_0140.QS');

Unit = qsData.Unit;
Unit2 = qsData2.Unit;
for id = 2:length(Unit)
%     if getProperty_Value(Unit,id,'Ang')==0 && strcmp(getProperty(Unit,id,'off'),'0') && getProperty_Value(Unit,id,'Ue')>0.5
%         disp(['id=' getProperty(Unit,id,'id') ',' getProperty(Unit,id,'name') ' : ' getProperty(Unit,id,'node')])
%     end
    if getProperty_Value(Unit,id,'Ue')>0.5
        name = getProperty(Unit,id,'name');
        id2 = findData(Unit2,'name',name);
        detAng = getProperty_Value(Unit,id,'Ang')-getProperty_Value(Unit2,id2,'Ang');
        disp([getProperty(Unit,id,'name') '>>>  Ue=' getProperty(Unit,id,'Ue') ', Ang=' getProperty(Unit,id,'Ang'), ...
            ',Ue2=' getProperty(Unit2,id2,'Ue') ', Ang2=' getProperty(Unit2,id2,'Ang') ',detAng=' num2str(detAng)]);
    end
end

% Bus = qsData.Bus;
% for id = 2:length(Bus)
%     if getProperty_Value(Bus,id,'Ang')==0 && strcmp(getProperty(Bus,id,'off'),'0') && getProperty_Value(Bus,id,'V')>0.5
%         disp(['id=' getProperty(Bus,id,'id') ',' getProperty(Bus,id,'name') ' : ' getProperty(Bus,id,'node')])
%     end
% end