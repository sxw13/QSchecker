%线路潮流校验
QSFilePath = 'QSdata\20140611_1200.QS';
qsData = readQSFile(QSFilePath);
resultFile = fopen('report\reportLine.csv','w');
ACline = qsData.ACline;
TopoNode = qsData.TopoNode;
Compensator_P = qsData.Compensator_P;
Bus = qsData.Bus;

fprintf(resultFile,'线路编号,线路名称,QSI端有功,计算I端有功,I端有功差值,QSI端无功,计算I端无功,I端无功差值,QSJ端有功,计算J端有功,J端有功差值,QSJ端无功,计算J端无功,J端无功差值\n');
for id = 2:length(ACline)
    try
        if strcmp(getProperty(ACline,id,'I_off'),'1') || strcmp(getProperty(ACline,id,'J_off'),'1') continue; end
        
        nodeName1 = getProperty(ACline,id,'I_node');
        nodeName2 = getProperty(ACline,id,'J_node');
        nodeId1 = findData(TopoNode,'name',nodeName1);
        nodeId2 = findData(TopoNode,'name',nodeName2);
        
        V1 = str2num(getProperty(TopoNode,nodeId1,'v'))*str2num(getProperty(TopoNode,nodeId1,'vbase'));
        U1 = V1*exp(str2num(getProperty(TopoNode,nodeId1,'ang'))/180*pi*1i);
        V2 = str2num(getProperty(TopoNode,nodeId2,'v'))*str2num(getProperty(TopoNode,nodeId2,'vbase'));
        U2 = V2*exp(str2num(getProperty(TopoNode,nodeId2,'ang'))/180*pi*1i);

        R = str2num(getProperty(ACline,id,'R'));
        X = str2num(getProperty(ACline,id,'X'));
        B = str2num(getProperty(ACline,id,'B'))*2;
        Z = R + X*1i;
        S12 = U1*conj((U1-U2)/Z)-abs(U1)^2*B/2*1i;
        S21 = U2*conj((U2-U1)/Z)-abs(U2)^2*B/2*1i;
        PI = real(S12);QI = imag(S12);
        PJ = real(S21);QJ = imag(S21);
        
        lineName = getProperty(ACline,id,'name');
        compids = findData(Compensator_P,'position',lineName);
        for compid = compids
            switch getProperty(Compensator_P,compid,'node')
                case nodeName1
                    QI = QI - str2num(getProperty(Compensator_P,compid,'Q'));
                    QJ = QJ + str2num(getProperty(Compensator_P,compid,'Q'));
                case nodeName2
                    QI = QI + str2num(getProperty(Compensator_P,compid,'Q'));
                    QJ = QJ - str2num(getProperty(Compensator_P,compid,'Q'));
            end
        end
        
        PI_QS = getProperty(ACline,id,'I_P');
        QI_QS = getProperty(ACline,id,'I_Q');
        PJ_QS = getProperty(ACline,id,'J_P');
        QJ_QS = getProperty(ACline,id,'J_Q');
        
        reportline = [getProperty(ACline,id,'id') ',' lineName ','];
        reportline = [reportline PI_QS ',' num2str(PI) ',' num2str(abs(PI-str2num(PI_QS))) ','];
        reportline = [reportline QI_QS ',' num2str(QI) ',' num2str(abs(QI-str2num(QI_QS))) ','];
        reportline = [reportline PJ_QS ',' num2str(PJ) ',' num2str(abs(PJ-str2num(PJ_QS))) ','];
        reportline = [reportline QJ_QS ',' num2str(QJ) ',' num2str(abs(QJ-str2num(QJ_QS))) '\n'];
        fprintf(resultFile,reportline);
        
    catch e
        disp(ACline{id});
    end
end
fclose(resultFile);
