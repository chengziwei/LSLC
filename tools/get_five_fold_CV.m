clc;clear;
totalCV = 5;
deleteData=1;
data_name = ['arts','birds','bookmarks','education',...
    'emotions','flags','genbase','languagelog','medical','rcvsubset1_top944',...
    'rcvsubset2_top944','rcvsubset3_top944','recreation','yeast'];
%%  make the directory of index, it it do not exist
if isempty(dir('index'))
    mkdir index;
else
    rmdir('index', 's') %rmdir;
end
%%
for i=1:14
% for i=3:3
    load(['data/',num2str(i),'.mat']);
    
    if exist('train_data','var')==1
    data    = [train_data;test_data];
    target  = [train_target,test_target];
        if deleteData == 1
            clear train_data test_data train_target test_target
        end
    end
    data      = double (data);
    target = target' ;
    target(target~=1)=0;
    num_data  = size(data,1);
    temp_data = data + eps;
    temp_data = temp_data./repmat(sqrt(sum(temp_data.^2,2)),1,size(temp_data,2));
    if sum(sum(isnan(temp_data)))>0
        temp_data = data+eps;
        temp_data = temp_data./repmat(sqrt(sum(temp_data.^2,2)),1,size(temp_data,2));
    end
    temp_data = [temp_data,ones(num_data,1)];
    
    %%  Ϊÿ�����ݼ�����Ŀ¼
    if isempty(dir(['index/',num2str(i)]))
        mkdir(['index/',num2str(i)]);
    end
    %%  Ϊÿ�����ݴ���ȱʧ��ǩ��ͬ�̶�
    for percent=0.1:0.1:0.6
%      for percent=0.3:0.1:0.3
        %%  ÿ�����ݼ��ظ�ʮ��
        if isempty(dir(['index/',num2str(i),'/',num2str(percent)]))
            mkdir(['index/',num2str(i),'/',num2str(percent)]);
        end
        for j=1:10 
%         for j=9:9 
            if isempty(dir(['index/',num2str(i),'/',num2str(percent),'/',num2str(j)]))
                mkdir(['index/',num2str(i),'/',num2str(percent),'/',num2str(j)]);
            end
            for k=1:totalCV %��������
%             for k=5:totalCV %��������
            %%  index/i/j/indexi.mat ith fold cv
                randorder = randperm(num_data);
                assert(k <= 10);
                assert(totalCV <= 10);

                slice = ceil(num_data/totalCV);
                test_data = temp_data(randorder((k - 1) * slice + 1: min( k * slice , num_data ) ) ,:);
                test_target = target(randorder((k - 1) * slice + 1: min( k * slice , num_data ) ) ,:);

                train_data = temp_data(setdiff(randorder,randorder((k - 1) * slice + 1: min( k * slice , num_data ) )),:);
                train_target = target(setdiff(randorder,randorder((k - 1) * slice + 1: min( k * slice , num_data ) )),:);
                % ���첻����ѵ�����ݱ�ǩ��
                bQuiet = 1 ; %����ʾ��Ϣ
                [IncompleteTarget, ~, ~, ~,J] = getIncompleteTarget(train_target, percent, bQuiet) ;
                filename = ['index/',num2str(i),'/',num2str(percent),'/',num2str(j),'/',num2str(k),'.mat'] ;
                save(filename,'test_data','test_target','train_data','train_target','J','IncompleteTarget');
%                 save(['index/',num2str(i),'/',num2str(percent),'/',num2str(j),'/',num2str(k),'.mat']);
                clear train_data test_data train_target test_target filename J IncompleteTarget
            end
        end
    end
    clear temp_data target data
end