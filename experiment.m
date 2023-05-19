clc;clear;
databaseNum = 2 ;
totalCV = 5;
repetitions = 5;
totalPercent = 0.6;
% data_name = {'arts','birds','education',...
%     'emotions','flags','genbase','languagelog','medical','rcv1subset1_top944',...
%     'rcv1subset2_top944','rcv1subset3_top944','recreation','yeast'};
data_name = {'flags','genbase','rcv1subset1_top944','rcv1subset2_top944','rcv1subset3_top944','scene','CAL500','Stackex_chemistry',...
    'Stackex_chess','Stackex_cooking','Stackex_cs','Stackex_philosophy','medical'};
execl_localtion = {'A','D','G','J','M','P','S'} ;
tic
for i=2:databaseNum
    %% �������ݿ�
    [ temp_data,target,num_data] = loadDataBase( data_name{i});
    %% ���ò�����GPU��
%     temp_data = gpuArray(temp_data);
%     target = gpuArray(target);
   

    %% Ϊÿ�����ݴ���ȱʧ��ǩ��ͬ�̶�
    for percent=0.6:0.1:totalPercent
       %% ����ÿ���㷨���յ����ݽ����¼����
%         LSML_cvResult  = zeros(16,totalCV);
        LSLC_cvResult  = zeros(16,totalCV);
%         GLOCAL_cvResult  = zeros(16,totalCV);
%         LIFT_cvResult = zeros(16,totalCV);
%         LLSF_cvResult = zeros(16,totalCV);
%         LPLC_cvResult = zeros(16,totalCV);
%         MLKNN_cvResult = zeros(16,totalCV);
       %% ��ʼ����
        for repetition=1:repetitions %�ظ�ʮ��
            for cv=1:totalCV %��������
                [train_data,train_target,IncompleteTarget,J,test_data,test_target] = createData( ...
                    temp_data,target,num_data,cv,totalCV,percent ); %��ȡ���ۺ�������Լ�ȱʧ�ı�ǩ���ݼ�
              
               %% ����ÿһ���㷨
%                [ tmpResult_MLKNN ] = mlknn_main( train_data,IncompleteTarget,test_data,test_target ) ;
%                [ tmpResult_LPLC ] = lplc_main( train_data,IncompleteTarget,test_data,test_target ) ;
%                [ tmpResult_LLSF ] = llsf_main( train_data,IncompleteTarget,test_data,test_target ) ;
%                [ tmpResult_LIFT ] = lift_main( train_data,IncompleteTarget,test_data,test_target ) ;
%                [ tmpResult_GLOCAL ] = glocal_main( train_data,train_target,J,test_data,test_target ) ;
%                [ tmpResult_LSML ] = lsml_main( train_data,IncompleteTarget,test_data,test_target ) ;
               [ tmpResult_LSLC,modelLSLC] = lslc_main( train_data,IncompleteTarget,test_data,test_target ) ;
               
               %% ��¼���
%                 MLKNN_cvResult(:,cv) = MLKNN_cvResult(:,cv) + tmpResult_MLKNN ;
%                 LPLC_cvResult(:,cv)  = LPLC_cvResult(:,cv) + tmpResult_LPLC ;
%                 LLSF_cvResult(:,cv)  = LLSF_cvResult(:,cv) + tmpResult_LLSF ;
%                 LIFT_cvResult(:,cv)  = LIFT_cvResult(:,cv) + tmpResult_LIFT ;
%                 GLOCAL_cvResult(:,cv)  = GLOCAL_cvResult(:,cv) + tmpResult_GLOCAL ;
%                 LSML_cvResult(:,cv)  = LSML_cvResult(:,cv) + tmpResult_LSML ;
                LSLC_cvResult(:,cv)  = LSLC_cvResult(:,cv) + tmpResult_LSLC ;
            end
        end
        %% �������ݵ�ƽ��ֵ
%         [ MLKNN_Avg_Result ]  = cptavg( MLKNN_cvResult,repetitions ) ;
%         [ LPLC_Avg_Result ]   = cptavg( LPLC_cvResult,repetitions ) ;
%         [ LLSF_Avg_Result ]   = cptavg( LLSF_cvResult,repetitions ) ;
%         [ LIFT_Avg_Result ]   = cptavg( LIFT_cvResult,repetitions ) ;
%         [ GLOCAL_Avg_Result ] = cptavg( GLOCAL_cvResult,repetitions ) ;
%         [ LSML_Avg_Result ]   = cptavg( LSML_cvResult,repetitions ) ;
        [ LSLC_Avg_Result ] = cptavg( LSLC_cvResult,repetitions ) ;
       %% ��������浽Excel
%        Avg_Result = {MLKNN_Avg_Result,LPLC_Avg_Result,LLSF_Avg_Result,...
%           LIFT_Avg_Result,GLOCAL_Avg_Result ,LSML_Avg_Result,LSMLPN_Avg_Result} ;
%          Avg_Result = {LSML_Avg_Result,LSMLPN_Avg_Result} ;
%        save2execl( data_name{i},Avg_Result,percent,execl_localtion )
% save2execl( data_name{i},LLSF_Avg_Result,percent,execl_localtion )
xlswrite(['E:\matlab\SCI\LSLC\wpn\pn.xlsx'],LSMLPN_Avg_Result,num2str(percent),execl_localtion{1})
% save2execl( data_name{i},LSLC_Avg_Result,modelLSLC.loss,percent,execl_localtion );
    end
   
    clear temp_data target train_data train_target IncompleteTarget J test_data test_target num_data
end
toc