clc;
qsData = readQSFile('QSdata\20140714_0455.QS');

Unit = qsData.Unit;
for id = 2:length(Unit)
%     if getProperty_Value(Unit,id,'Ang')==0 && strcmp(getProperty(Unit,id,'off'),'0') && getProperty_Value(Unit,id,'Ue')>0.5
%         disp(['id=' getProperty(Unit,id,'id') ',' getProperty(Unit,id,'name') ' : ' getProperty(Unit,id,'node')])
%     end
    if getProperty_Value(Unit,id,'Ue')>0.5
        disp([getProperty(Unit,id,'name') '>>>  Ue=' getProperty(Unit,id,'Ue') ', Ang=' getProperty(Unit,id,'Ang')]);
    end
end

% Bus = qsData.Bus;
% for id = 2:length(Bus)
%     if getProperty_Value(Bus,id,'Ang')==0 && strcmp(getProperty(Bus,id,'off'),'0') && getProperty_Value(Bus,id,'V')>0.5
%         disp(['id=' getProperty(Bus,id,'id') ',' getProperty(Bus,id,'name') ' : ' getProperty(Bus,id,'node')])
%     end
% end