fileName = uigetfile('.txt','Choose your .txt input file');
fileID = fopen(fileName);
variables = struct();
variable_counter = 0;
variable_names = cell(20,1);

while ~feof(fileID)
    tline = fgetl(fileID);
    
    if(tline ~=-1)
       
        if(tline(1) ~= 35 && ~(tline(1) >= 48 && tline(1) <= 57))
            variable_counter = variable_counter + 1;
            variable_names{variable_counter} = tline(1:length(tline)-1);
            
            tline = fgetl(fileID);

            variables.(variable_names{variable_counter})= textscan(tline, '%f');
                
        
        end
        
    end
    
end
fclose(fileID);