%��ѹ������У��
qsData = readQSFile('QSdata\20140611_1200.QS');

TopoNode = qsData('TopoNode');
Transformer = qsData('Transformer');
type = 2; %1�������迹����ѹ�ࣻ2���������迹����ѹ��

resultFile = fopen('report\reportTrans2.csv','w');

fprintf(resultFile,'��ѹ�����,��ѹ������,QSI���й�,����I���й�,QSI���޹�,����I���޹�,QSK���й�,����K���й�,QSK���޹�,����K���޹�,QSJ���й�,����J���й�,QSJ���޹�,����J���޹�\n');
fprintf(resultFile,'��ѹ�����,��ѹ������,I�˽ڵ�����,I�˽ڵ��ѹ,I�˽ڵ����,,K�˽ڵ�����,K�˽ڵ��ѹ,K�˽ڵ����,,J�˽ڵ�����,J�˽ڵ��ѹ,J�˽ڵ����\n');
TopoNodeNameMap = startFind(TopoNode,'name');

for idcon = keys(Transformer)
    try
        id = idcon{1};
        if strcmp(getProperty(Transformer,id,'I_off'),'1') || strcmp(getProperty(Transformer,id,'K_off'),'1') || strcmp(getProperty(Transformer,id,'J_off'),'1') continue; end

        nodeNameI = getProperty(Transformer,id,'I_node');
        nodeNameK = getProperty(Transformer,id,'K_node');
        nodeNameJ = getProperty(Transformer,id,'J_node');
        
        transName = getProperty(Transformer,id,'name');
        
        if strcmp(nodeNameK,'''''')  %����˫�����ѹ��
            nodeIdIcon = TopoNodeNameMap(nodeNameI);
            nodeIdJcon = TopoNodeNameMap(nodeNameJ);
            nodeIdI = nodeIdIcon{1};
            nodeIdJ = nodeIdJcon{1};

            VI = str2num(getProperty(TopoNode,nodeIdI,'v'));
            AI = getProperty(TopoNode,nodeIdI,'ang');
            UI = VI*exp(str2num(AI)/180*pi*1i);
            VJ = str2num(getProperty(TopoNode,nodeIdJ,'v'));
            AJ = getProperty(TopoNode,nodeIdJ,'ang');
            UJ = VJ*exp(str2num(AJ)/180*pi*1i);

            kI = str2num(getProperty(Transformer,id,'I_t'));
            kJ = str2num(getProperty(Transformer,id,'J_t'));

            RI = str2num(getProperty(Transformer,id,'Ri*'));
            XI = str2num(getProperty(Transformer,id,'Xi*'));
            ZI = RI + XI*1i;
            RJ = str2num(getProperty(Transformer,id,'Rj*'));
            XJ = str2num(getProperty(Transformer,id,'Xj*'));
            ZJ = RJ + XJ*1i;

            switch type
                case 1
                    SI = UI/kI*conj((UI/kI-UJ/kJ)/(ZI/kI^2+ZJ/kJ^2));
                    SJ = UJ/kJ*conj((UJ/kJ-UI/kI)/(ZI/kI^2+ZJ/kJ^2));
                case 2
                    SI = UI/kI*conj((UI/kI-UJ/kJ)/(ZI+ZJ));
                    SJ = UJ/kJ*conj((UJ/kJ-UI/kI)/(ZI+ZJ));
            end


            
            PI = real(SI)*100;QI = imag(SI)*100;
            PJ = real(SJ)*100;QJ = imag(SJ)*100;


            reportline = [getProperty(Transformer,id,'id') ',' transName ','];
            reportline = [reportline getProperty(Transformer,id,'I_P') ',' num2str(PI) ','];
            reportline = [reportline getProperty(Transformer,id,'I_Q') ',' num2str(QI) ','];
            reportline = [reportline  ',,'];
            reportline = [reportline  ',,'];
            reportline = [reportline getProperty(Transformer,id,'J_P') ',' num2str(PJ) ','];
            reportline = [reportline getProperty(Transformer,id,'J_Q') ',' num2str(QJ) '\n'];
            fprintf(resultFile,reportline);
              %          fprintf(resultFile,',,I�˽ڵ�����,I�˽ڵ��ѹ,I�˽ڵ����,,K�˽ڵ�����,K�˽ڵ��ѹ,K�˽ڵ����,,J�˽ڵ�����,J�˽ڵ��ѹ,J�˽ڵ����\n');
            reportline = ',,';
            reportline = [reportline nodeNameI ',' num2str(VI) ',' AI ',,'];
            reportline = [reportline ',,,,'];
            reportline = [reportline nodeNameJ ',' num2str(VJ) ',' AJ ',\n'];
            fprintf(resultFile,reportline);
            
        else   %�����������ѹ��
            nodeIdIcon = TopoNodeNameMap(nodeNameI);
            nodeIdKcon = TopoNodeNameMap(nodeNameK);
            nodeIdJcon = TopoNodeNameMap(nodeNameJ);
            
            nodeIdI = nodeIdIcon{1};nodeIdK = nodeIdKcon{1};nodeIdJ = nodeIdJcon{1};

            VI = str2num(getProperty(TopoNode,nodeIdI,'v'));
            AI = getProperty(TopoNode,nodeIdI,'ang');
            UI = VI*exp(str2num(AI)/180*pi*1i);
            VK = str2num(getProperty(TopoNode,nodeIdK,'v'));
            AK = getProperty(TopoNode,nodeIdK,'ang');
            UK = VK*exp(str2num(AK)/180*pi*1i);
            VJ = str2num(getProperty(TopoNode,nodeIdJ,'v'));
            AJ = getProperty(TopoNode,nodeIdJ,'ang');
            UJ = VJ*exp(str2num(AJ)/180*pi*1i);

            kI = str2num(getProperty(Transformer,id,'I_t'));
            kK = str2num(getProperty(Transformer,id,'K_t'));
            kJ = str2num(getProperty(Transformer,id,'J_t'));

            RI = str2num(getProperty(Transformer,id,'Ri*'));
            XI = str2num(getProperty(Transformer,id,'Xi*'));
            ZI = RI + XI*1i;
            RK = str2num(getProperty(Transformer,id,'Rk*'));
            XK = str2num(getProperty(Transformer,id,'Xk*'));
            ZK = RK + XK*1i;
            RJ = str2num(getProperty(Transformer,id,'Rj*'));
            XJ = str2num(getProperty(Transformer,id,'Xj*'));
            ZJ = RJ + XJ*1i;

            switch type
                case 1
                    UB = (UI/kI/ZI+UJ/kJ/ZJ+UK/kK/ZK)/(1/ZI*kI^2+1/ZK*kK^2+1/ZJ*kJ^2);  %�������Ե��ѹ
                    if ZI==0 UB=UI/kI;
                    elseif ZK==0 UB=UK/kK;
                    elseif ZJ==0 UB=UJ/kJ;
                    end
                case 2
                    UB = (UI/kI/ZI+UJ/kJ/ZJ+UK/kK/ZK)/(1/ZI+1/ZK+1/ZJ);  %�������Ե��ѹ
                    if ZI==0 UB=UI/kI;
                    elseif ZK==0 UB=UK/kK;
                    elseif ZJ==0 UB=UJ/kJ;
                    end
            end

            SI = UI/kI*conj((UI/kI-UB)/ZI);
            SK = UK/kK*conj((UK/kK-UB)/ZK);
            SJ = UJ/kJ*conj((UJ/kJ-UB)/ZJ);
            
            if ZI==0 SI=-SK-SJ;
            elseif ZK==0 SK=-SI-SJ;
            elseif ZJ==0 SJ=-SI-SK;
            end


            PI = real(SI)*100;QI = imag(SI)*100;
            PK = real(SK)*100;QK = imag(SK)*100;
            PJ = real(SJ)*100;QJ = imag(SJ)*100;


            reportline = [getProperty(Transformer,id,'id') ',' transName ','];
            reportline = [reportline getProperty(Transformer,id,'I_P') ',' num2str(PI) ','];
            reportline = [reportline getProperty(Transformer,id,'I_Q') ',' num2str(QI) ','];
            reportline = [reportline getProperty(Transformer,id,'K_P') ',' num2str(PK) ','];
            reportline = [reportline getProperty(Transformer,id,'K_Q') ',' num2str(QK) ','];
            reportline = [reportline getProperty(Transformer,id,'J_P') ',' num2str(PJ) ','];
            reportline = [reportline getProperty(Transformer,id,'J_Q') ',' num2str(QJ) '\n'];
            fprintf(resultFile,reportline);
  %          fprintf(resultFile,',,I�˽ڵ�����,I�˽ڵ��ѹ,I�˽ڵ����,,K�˽ڵ�����,K�˽ڵ��ѹ,K�˽ڵ����,,J�˽ڵ�����,J�˽ڵ��ѹ,J�˽ڵ����\n');
            reportline = ',,';
            reportline = [reportline nodeNameI ',' num2str(VI) ',' AI ',,'];
            reportline = [reportline nodeNameK ',' num2str(VK) ',' AK ',,'];
            reportline = [reportline nodeNameJ ',' num2str(VJ) ',' AJ ',\n'];
            fprintf(resultFile,reportline);
        end
        
    catch e
        name = getProperty(Transformer,id,'name');
        disp(name);
    end
end
fclose(resultFile);
