fid = fopen('Test.txt');
numLines = -1;
while feof(fid) == 0
    stepper = fgetl(fid);
    numLines = numLines+1;
end
fclose(fid);

time_fitness = dlmread('Test.txt',',',[0 0 numLines 1]);

test = dlmread('Test.txt',',',[0 3 numLines 3]);

plot(time_fitness(:,1), time_fitness(:,2))