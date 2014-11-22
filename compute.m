
typesMayo={};
stack = {};
s = 1;
display('Mayo:');
files=dir('Patrones\Mayo');

count=1;
for file=files'
    if(strcmp(file.name,'.') || strcmp(file.name,'..'))
        continue
    end
    try
        t=init(strcat('Patrones\Mayo\',file.name));
        typesMayo{count}=t;
    
        count=count+1;
        display(strcat('done with ',file.name));
    catch exc
        display(strcat('Exception!:',exc.message))
        stack{s}=exc.stack;
        s=s+1;
    end
end