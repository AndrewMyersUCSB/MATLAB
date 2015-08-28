if variables.killed_on_update{1} > variables.N{1}
     error('# organisms killed must be less than starting # organisms')
end


 
if variables.N{1} > 10000
   answer = questdlg('Large values of N may take a long time!  Are you sure you want to continue?', 'Warning', 'Yes', 'No', 'Yes');
   if(strcmp(answer,'No') || strcmp(answer, ''))
       ME = MException('quit');
       throw(ME);
   end
end

if variables.mu1{1} <= 0.01 || variables.mu2{1} <= 0.01
    answer = questdlg('Low mutation rates may show little change.  Are you sure you want to continue?', 'Warning', 'Yes', 'No', 'Yes');
   if(strcmp(answer,'No') || strcmp(answer, ''))
       ME = MException('quit');
       throw(ME);
   end
end