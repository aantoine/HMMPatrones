function t2 = calc(path)
files=dir(path);
count=1;
stack={};
s = 1;
for file=files'
    if(strcmp(file.name,'.') || strcmp(file.name,'..'))
        continue
    end
    try
        t=init(strcat(path,file.name));
        t2{count}=t;

        count=count+1;
        display(strcat('done with ',file.name));
    catch exc
        display(strcat('Exception!:',exc.message))
        stack{s}=exc.stack;
        s=s+1;
    end
end
end