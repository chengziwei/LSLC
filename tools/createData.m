function [ train_data,train_target,IncompleteTarget,J,test_data,test_target] = createData( temp_data,target,num_data,k,totalCV,percent )
    randorder = randperm(num_data);
    assert(k <= 5);
    assert(totalCV <= 5);
    target(target~=1)=0 ;
    
    slice = ceil(num_data/totalCV);
    test_data = temp_data(randorder((k - 1) * slice + 1: min( k * slice , num_data ) ) ,:);
    test_target = target(randorder((k - 1) * slice + 1: min( k * slice , num_data ) ) ,:);

    train_data = temp_data(setdiff(randorder,randorder((k - 1) * slice + 1: min( k * slice , num_data ) )),:);
    train_target = target(setdiff(randorder,randorder((k - 1) * slice + 1: min( k * slice , num_data ) )),:);
    % 构造不完整训练数据标签集
    bQuiet = 1 ; %不显示信息
    [IncompleteTarget, ~, ~, ~,J] = getIncompleteTarget(train_target, percent, bQuiet) ;
end

