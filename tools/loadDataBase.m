function [ temp_data,target,num_data] = loadDataBase( dataname )
    deleteData=1;
    load(['E:\MATLAB2016b\bin\SCI\data\',dataname,'.mat']);
    disp(['获取数据集',dataname]) ;
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
end

