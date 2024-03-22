
% rename of the specific files according to the string need to be repleaced
% when change the channle name, we should modify the name of the tune files
% correspond.
%
clear
% work directory
directory = 'C:\SandBox\CART\Latest\cart-cicd-j69\rndb_j69\RNDB\cars\Concept\db\tuning\lhd'; 
 
% get the file list
fileList = dir(fullfile(directory)); 
j=0;
str=[];
for i = 1:length(fileList)
    filename = fileList(i).name; % ??????????
    if strfind(filename, 'fas') > 0 % ???????????????
        j=j+1;
        %filename
         newFilename = replace(filename, 'fas', 'bw');% ????????????
        [num2str(j),'  Original:',filename,'     After:',newFilename]
        oldFilePath = fullfile(directory, filename); % ???????????
        newFilePath = fullfile(directory, newFilename); % ??????????
        %str=strvcat(str,[num2str(j),'  Original:',filename,'     After:',newFilename]);
        %input_value = input('please input y or n?', 's');
        del_cmd=['svn',' ', 'delete',' ',newFilePath];
        full_cmd=['svn',' ', 'rename',' ',oldFilePath,' ',newFilePath];
        %if(input_value(1)=='y')
        if(1)    
            %disp("del the file name: %s\n",oldFilePath);
            if exist(newFilePath, 'file') == 2
                disp('File exist');
                [SUCCESS,RESULT]=system(del_cmd);
                if SUCCESS~=0
                    disp('ERROR');
                end
                [SUCCESS,RESULT]=system(full_cmd);
                if SUCCESS~=0
                    disp('ERROR');  
                end
            else
                disp('No file');
                [SUCCESS,RESULT]=system(full_cmd);
                if SUCCESS~=0
                    disp('ERROR');  
                end
            end
        else
            disp("don't replace the file\n")
        end
        str=strvcat(str,[num2str(j),'  Original:',filename,'     After:',newFilename,' sucess']);
    end
end
str