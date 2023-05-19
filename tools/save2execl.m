% function save2execl( data_name,result,percent,execl_localtion )
function save2execl( data_name,result,loss,percent,execl_localtion )
% function save2execl( data_name,result,percent,execl_localtion )
%     num_algorithm = size(result,2) ;
%     for i=1:num_algorithm
%         xlswrite(['E:\matlab\SCI\SCI\',data_name,'.xlsx'],result{i},num2str(percent),execl_localtion{i});
%     end
xlswrite(['E:\MATLAB2016b\bin\SCI\LSLC\wpn\',data_name,'Iter.xlsx'],result,num2str(percent),execl_localtion{1});
xlswrite(['E:\MATLAB2016b\bin\SCI\LSLC\wpn\',data_name,'Iter.xlsx'],loss,num2str(percent),execl_localtion{2});
end

