%Runs specified rules, settings.txt.


%Default values, in case no settings file.

variables = struct();
name_counter = 0;
names_array = cell(20,1);

fileID = fopen('settings.txt');
if(fileID == -1)
   names_array = {['N'],['mux'],['muy'],['updates'],['killed_on_update'],['asexual'],['mut_effect'],['data_type'],['plot_image'],['save_image']};
   name_counter = 10;
   
   variables.(names_array{1}) = 2000;
   variables.(names_array{2}) = 0.05;
   variables.(names_array{3}) = 0.05;
   variables.(names_array{4}) = 50000;
   variables.(names_array{5}) = 200;
   variables.(names_array{6}) = 1;
   variables.(names_array{7}) = 0.05;
   variables.(names_array{8}) = 1;
   variables.(names_array{9}) = 1;
   variables.(names_array{10}) = 1;
  
else
    while ~feof(fileID)
    tline = fgetl(fileID);
    
    if(tline ~=-1)
       
        if(tline(1) ~= 35 && ~(tline(1) >= 48 && tline(1) <= 57))
            name_counter = name_counter + 1;
            names_array{name_counter} = tline(1:length(tline)-1);
            
            tline = fgetl(fileID);

            variables.(names_array{name_counter})= textscan(tline, '%f');
                
        
        end
        
    end
    

    end
end


fclose(fileID);

if variables.(names_array{5}) > variables.(names_array{1})
    error('# of organisms killed must be less than starting # of organisms\n')
end

