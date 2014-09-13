%���˽ڵ㳱��У��
qsData = readQSFile('QSdata\20140714_0455.QS');
% resultFile = fopen('E:\ͳ�Ƶ�ѹ\�ʼ��ĵ�\checker_2\reportTopoNode_OnlyTopoNode.csv','w');
resultFile = fopen('report\reportDetailTopoNode.csv','w');
TopoNode = qsData.TopoNode;
Transformer = qsData.Transformer;
Load = qsData.Load;
ACline = qsData.ACline;
Unit = qsData.Unit;
Compensator_P = qsData.Compensator_P;

% fprintf(resultFile,'�ڵ���,�ڵ�����,�����й�,�����й�,��·1�й�,��·2�й�,��ѹ���й�,�й��ܺ�,�����޹�,�����޹�,��·1�޹�,��·2�޹�,��ѹ���޹�,�޹�����,�޹��ܺ�\n');

%���<TopoNode>ģ���нڵ�Ĺ���ƽ�����
for id = 2:length(TopoNode) 
    detailedLines='';
    try
        if strcmp(getProperty(TopoNode,id,'name'),'''''') continue; end
        
        nodeName = getProperty(TopoNode,id,'name');
        island = getProperty(TopoNode,id,'island');
        if strcmp(island,'����.��0')
            %Unit
            Gen = findData(Unit,'node',nodeName);
            if ~isempty(Gen)            
                  gen_P = getProperty_Value(Unit,Gen,'P');
                  gen_Q = getProperty_Value(Unit,Gen,'Q');              
                  for id_count=1:length(Gen)
                      part_id = Gen(1,id_count);
                      P_line = [getProperty(Unit,part_id,'P') '(P)'];
                      Q_line = [getProperty(Unit,part_id,'Q') '(Q)'];
                      id_line= [getProperty(Unit,part_id,'id') '(id)'];
                      name_line= getProperty(Unit,part_id,'name');
                      detailedLines =[detailedLines ',' '�������:' ',' id_line ',' name_line ',' P_line ',' Q_line '\n'];
                  end
            else
                  gen_P = 0;
                  gen_Q = 0;
            end

            %ACline
            line_I = findData(ACline,'I_node',nodeName);
            line_J = findData(ACline,'J_node',nodeName);
            if ~isempty(line_I)
                line_I_P = getProperty_Value(ACline,line_I,'I_P');
                line_I_Q = getProperty_Value(ACline,line_I,'I_Q');
                for id_count=1:length(line_I)
                    part_id = line_I(1,id_count);
                    id_line = [getProperty(ACline,part_id,'id') '(id)'];
                    name_line= getProperty(ACline,part_id,'name');
                    PI_line = [getProperty(ACline,part_id,'I_P') '(I���й�)'];
                    QI_line = [getProperty(ACline,part_id,'I_Q') '(I���޹�)'];
                    nodeJ_line=[getProperty(ACline,part_id,'J_node') '(J�˽ڵ�)'];
                    PJ_line = [getProperty(ACline,part_id,'J_P') '(J���й�)'];                
                    QJ_line = [getProperty(ACline,part_id,'J_Q') '(J���޹�)'];
                    detailedLines =[detailedLines ',' '��·��' ',' id_line ',' name_line ',' PI_line ',' QI_line ',' nodeJ_line ',' PJ_line ',' QJ_line  '\n'];
                end 
            else
                line_I_P = 0;
                line_I_Q = 0;
            end
            if  ~isempty(line_J)
                line_J_P = getProperty_Value(ACline,line_J,'J_P');
                line_J_Q = getProperty_Value(ACline,line_J,'J_Q');
                for id_count=1:length(line_J)
                    part_id = line_J(1,id_count);
                    id_line = [getProperty(ACline,part_id,'id') '(id)'];
                    name_line= getProperty(ACline,part_id,'name');
                    PJ_line = [getProperty(ACline,part_id,'J_P') '(J���й�)'];
                    QJ_line = [getProperty(ACline,part_id,'J_Q') '(J���޹�)'];
                    nodeI_line=[getProperty(ACline,part_id,'I_node') '(I�˽ڵ�)'];
                    PI_line = [getProperty(ACline,part_id,'I_P') '(I���й�)'];                
                    QI_line = [getProperty(ACline,part_id,'I_Q') '(I���޹�)'];
                    detailedLines =[detailedLines ',' '��·��' ',' id_line ',' name_line ',' PJ_line ',' QJ_line ',' nodeI_line ',' PI_line ',' QI_line  '\n'];
                end 
            else
                line_J_P = 0;
                line_J_Q = 0;
            end
            line_P = line_I_P + line_J_P;      
            line_Q = line_I_Q + line_J_Q;

            %Compensator_P
            Comp = findData(Compensator_P,'node',nodeName);   
            Comp_Q = 0;
            temp = 0;
            if ~isempty(Comp)
                for comp_id = 1:length(Comp)
                    position = getProperty(Compensator_P,Comp(1,comp_id),'position');
                    if strcmp(position,'''''')
                        temp = Comp_Q;
                        Comp_Q = getProperty_Value(Compensator_P,Comp(1,comp_id),'Q') + temp;
                        temp = 0;
                        compID_line = [getProperty(Compensator_P,Comp(1,comp_id),'id') '(id)'];
                        compName_line = getProperty(Compensator_P,Comp(1,comp_id),'name');
                        compQ_line = [getProperty(Compensator_P,Comp(1,comp_id),'Q') '(Q)'];
                        detailedLines =[detailedLines ',' '�޹�������' ',' compID_line ',' compName_line ',' compQ_line '\n'];
                    end
                end
            end

            %Transfer        
            Trans_I = findData(Transformer,'I_node',nodeName);
            Trans_J = findData(Transformer,'J_node',nodeName);
            Trans_K = findData(Transformer,'K_node',nodeName);
            if ~isempty(Trans_I)           
                Trans_I_P = getProperty_Value(Transformer,Trans_I,'I_P');
                Trans_I_Q = getProperty_Value(Transformer,Trans_I,'I_Q');
                for id_count=1:length(Trans_I)
                    part_id = Trans_I(1,id_count);
                    id_line = [getProperty(Transformer,part_id,'id') '(id)'];
                    name_line= getProperty(Transformer,part_id,'name');
                    PI_line = [getProperty(Transformer,part_id,'I_P') '(I���й�)'];
                    QI_line = [getProperty(Transformer,part_id,'I_Q') '(I���޹�)'];
                    nodeJ_line=[getProperty(Transformer,part_id,'J_node') '(J�˽ڵ�)'];
                    PJ_line = [getProperty(Transformer,part_id,'J_P') '(J���й�)'];                
                    QJ_line = [getProperty(Transformer,part_id,'J_Q') '(J���޹�)'];
                    nodeK_line=[getProperty(Transformer,part_id,'K_node') '(K�˽ڵ�)'];
                    PK_line = [getProperty(Transformer,part_id,'K_P') '(K���й�)'];                
                    QK_line = [getProperty(Transformer,part_id,'K_Q') '(K���޹�)'];                
                    detailedLines =[detailedLines ',' '��ѹ����' ',' id_line ',' name_line ',' PI_line ',' QI_line ',' nodeJ_line ',' PJ_line ',' QJ_line ',' nodeK_line ',' PK_line ',' QK_line '\n'];
                end 

            else
                Trans_I_P = 0;
                Trans_I_Q = 0;
            end
            if ~isempty(Trans_J)
                Trans_J_P = getProperty_Value(Transformer,Trans_J,'J_P');
                Trans_J_Q = getProperty_Value(Transformer,Trans_J,'J_Q');
                for id_count=1:length(Trans_J)
                    part_id = Trans_J(1,id_count);
                    id_line = [getProperty(Transformer,part_id,'id') '(id)'];
                    name_line= getProperty(Transformer,part_id,'name');
                    PJ_line = [getProperty(Transformer,part_id,'J_P') '(J���й�)'];
                    QJ_line = [getProperty(Transformer,part_id,'J_Q') '(J���޹�)'];
                    nodeI_line=[getProperty(Transformer,part_id,'I_node') '(I�˽ڵ�)'];
                    PI_line = [getProperty(Transformer,part_id,'I_P') '(I���й�)'];                
                    QI_line = [getProperty(Transformer,part_id,'I_Q') '(I���޹�)'];
                    nodeK_line=[getProperty(Transformer,part_id,'K_node') '(K�˽ڵ�)'];
                    PK_line = [getProperty(Transformer,part_id,'K_P') '(K���й�)'];                
                    QK_line = [getProperty(Transformer,part_id,'K_Q') '(K���޹�)'];                
                    detailedLines =[detailedLines ',' '��ѹ����' ',' id_line ',' name_line ',' PJ_line ',' QJ_line ',' nodeI_line ',' PI_line ',' QI_line ',' nodeK_line ',' PK_line ',' QK_line '\n'];
                end 
            else
                Trans_J_P = 0;
                Trans_J_Q = 0;
            end
            if ~isempty(Trans_K)            
                Trans_K_P = getProperty_Value(Transformer,Trans_K,'K_P');
                Trans_K_Q = getProperty_Value(Transformer,Trans_K,'K_Q');
                for id_count=1:length(Trans_K)
                    part_id = Trans_K(1,id_count);
                    id_line = [getProperty(Transformer,part_id,'id') '(id)'];
                    name_line= getProperty(Transformer,part_id,'name');
                    PK_line = [getProperty(Transformer,part_id,'K_P') '(K���й�)'];
                    QK_line = [getProperty(Transformer,part_id,'K_Q') '(K���޹�)'];
                    nodeJ_line=[getProperty(Transformer,part_id,'J_node') '(J�˽ڵ�)'];
                    PJ_line = [getProperty(Transformer,part_id,'J_P') '(J���й�)'];                
                    QJ_line = [getProperty(Transformer,part_id,'J_Q') '(J���޹�)'];
                    nodeI_line=[getProperty(Transformer,part_id,'I_node') '(I�˽ڵ�)'];
                    PI_line = [getProperty(Transformer,part_id,'I_P') '(I���й�)'];                
                    QI_line = [getProperty(Transformer,part_id,'I_Q') '(I���޹�)'];                
                    detailedLines =[detailedLines ',' '��ѹ����' ',' id_line ',' name_line ',' PK_line ',' QK_line ',' nodeJ_line ',' PJ_line ',' QJ_line ',' nodeI_line ',' PI_line ',' QI_line '\n'];
                end 
            else
                Trans_K_P = 0;
                Trans_K_Q = 0;
            end
            Trans_P = Trans_I_P + Trans_J_P + Trans_K_P;
            Trans_Q = Trans_I_Q + Trans_J_Q + Trans_K_Q;

            %Load
            load = findData(Load,'node',nodeName);
            if ~isempty(load)
                load_P = getProperty_Value(Load,load,'P');
                load_Q = getProperty_Value(Load,load,'Q');
                for id_count=1:length(load)
                      part_id = load(1,id_count);
                      P_line = [getProperty(Load,part_id,'P') '(P)'];
                      Q_line = [getProperty(Load,part_id,'Q') '(Q)'];
                      id_line= [getProperty(Load,part_id,'id') '(id)'];
                      name_line= getProperty(Load,part_id,'name');
                      detailedLines =[detailedLines ',' '����:' ',' id_line ',' name_line ',' P_line ',' Q_line '\n'];
                end             
            else
                 load_P = 0;
                 load_Q = 0;
            end
% fprintf(resultFile,'�ڵ���,�ڵ�����,�����й�,�����й�,��·1�й�,��·2�й�,��ѹ���й�,�й��ܺ�,�����޹�,�����޹�,��·1�޹�,��·2�޹�,��ѹ���޹�,�޹�����,�޹��ܺ�\n');
%            reportline = [getProperty(TopoNode,id,'id') ',' nodeName ',' num2str(gen_P) ',' num2str(load_P) ',' num2str(line_I_P) ',' num2str(line_J_P) ',' num2str(Trans_P) ',' num2str(gen_P-load_P-line_I_P-line_J_P-Trans_P) ','];
%            reportline = [reportline num2str(gen_Q) ',' num2str(load_Q) ',' num2str(line_I_Q) ',' num2str(line_J_Q) ',' num2str(Trans_Q) ',' num2str(Comp_Q) ',' num2str(gen_Q-load_Q-line_Q-Trans_Q+Comp_Q) '\n'];
            reportline = [getProperty(TopoNode,id,'id') '(id)' ',' nodeName ',' num2str(gen_P) '(�����й�)' ',' num2str(load_P) '(�����й�)' ',' num2str(line_I_P) '(I����·�й�)' ',' num2str(line_J_P) '(J����·�й�)' ',' num2str(Trans_P) '(��ѹ���й�)' ',' num2str(gen_P-load_P-line_I_P-line_J_P-Trans_P) '(�й��ܺ�)' ','];
            reportline = [reportline num2str(gen_Q) '(�����޹�)' ',' num2str(load_Q) '(�����޹�)' ',' num2str(line_I_Q) '(I����·�޹�)' ',' num2str(line_J_Q) '(J����·�޹�)' ',' num2str(Trans_Q) '(��ѹ���޹�)' ',' num2str(Comp_Q) '(�޹�����)' ',' num2str(gen_Q-load_Q-line_Q-Trans_Q+Comp_Q) '(�޹��ܺ�)' '\n'];
            
            fprintf(resultFile,reportline);
            fprintf(resultFile,detailedLines); 
        end
    catch e
        disp(e);
    end
end
%�Ƿ���Ҫ������ѹ������·������TopoNode�в����ڵĽڵ�
fclose(resultFile);
