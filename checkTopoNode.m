%拓扑节点潮流校验
qsData = readQSFile('QSdata\20140611_1200.QS');
resultFile = fopen('report\reportTopoNode.csv','w');
TopoNode = qsData.TopoNode;
Transformer = qsData.Transformer;
Load = qsData.Load;
ACline = qsData.ACline;
Unit = qsData.Unit;
Compensator_P = qsData.Compensator_P;


fprintf(resultFile,'节点编号,节点名称,发出有功,负荷有功,线路1有功,线路2有功,变压器有功,有功总和,发出无功,负荷无功,线路1无功,线路2无功,变压器无功,无功补偿,无功总和\n');
%检查<TopoNode>模块中节点的功率平衡情况
for id = 2:length(TopoNode) 
    try
        if strcmp(getProperty(TopoNode,id,'name'),'''''') continue; end
        
        nodeName = getProperty(TopoNode,id,'name');
        
        %Unit
        Gen = findData(Unit,'node',nodeName);
        if ~isempty(Gen)
              gen_P = getProperty_Value(Unit,Gen,'P');
              gen_Q = getProperty_Value(Unit,Gen,'Q');
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
        else
            line_I_P = 0;
            line_I_Q = 0;
        end
        if  ~isempty(line_J)
            line_J_P = getProperty_Value(ACline,line_J,'J_P');
            line_J_Q = getProperty_Value(ACline,line_J,'J_Q');
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
                    temp = Comp_Q %%%%%%%%%%%%%%%
                    Comp_Q = getProperty_Value(Compensator_P,Comp(1,comp_id),'Q') + temp  %%%%%%%%%%%%%%%%%%
                    temp = 0;
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
        else
            Trans_I_P = 0;
            Trans_I_Q = 0;
        end
        if ~isempty(Trans_J)
            Trans_J_P = getProperty_Value(Transformer,Trans_J,'J_P');
            Trans_J_Q = getProperty_Value(Transformer,Trans_J,'J_Q');
        else
            Trans_J_P = 0;
            Trans_J_Q = 0;
        end
        if ~isempty(Trans_K)            
            Trans_K_P = getProperty_Value(Transformer,Trans_K,'K_P');
            Trans_K_Q = getProperty_Value(Transformer,Trans_K,'K_Q');
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
        else
             load_P = 0;
             load_Q = 0;
        end
        
       reportline = [getProperty(TopoNode,id,'id') ',' nodeName ',' num2str(gen_P) ',' num2str(load_P) ',' num2str(line_I_P) ',' num2str(line_J_P) ',' num2str(Trans_P) ',' num2str(gen_P-load_P-line_I_P-line_J_P-Trans_P) ','];
       reportline = [reportline num2str(gen_Q) ',' num2str(load_Q) ',' num2str(line_I_Q) ',' num2str(line_J_Q) ',' num2str(Trans_Q) ',' num2str(Comp_Q) ',' num2str(gen_Q-load_Q-line_Q-Trans_Q+Comp_Q) '\n'];
       fprintf(resultFile,reportline);
        
    catch e
        disp(e);
    end
end
fclose(resultFile);
