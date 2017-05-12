%% step 1: load in files
filename = 'caffe.user-X10DRG-Q.bobauditore.log.INFO.20170511-101135.27527';
fid=fopen(filename,'r');

%% step 2: parameters
regpat = 'Iteration [0-9]+, loss = [0-9\.]+';
%regpat = 'Iteration [0-9]+ \([0-9]+\.[0-9]+ iter\/s\, [0-9]+.[0-9]+s\/[0-9]+ iters\), loss \= [0-9]+.[0-9]+';
iter = zeros(100000,1);
loss = zeros(100000,1);
p = 1;

%accuracy
regpat_accuracy = 'accuracy = [+|-]?\d*\.?\d*';
iter_top1 = zeros(100000,1);
iter_accuracy = zeros(100000,1);
p_accuracy = 1;

%% step 3: find
while ~feof(fid)
    newline=fgetl(fid);
    o3=regexpi(newline,regpat,'match');
    if ~isempty(o3)
        iterloss = sscanf(o3{1},'Iteration %d, loss = %f');
        %iterloss = sscanf(o3{1},'Iteration %d (%*f iter/s, %*fs/%*d iters), loss = %f');
        iter(p) = iterloss(1);
        loss(p) = iterloss(2);
        p=p+1;
    end;
    
    o3_accuracy=regexpi(newline,regpat_accuracy,'match');
    if ~isempty(o3_accuracy)
        iter_accuracy_tmp = sscanf(o3_accuracy{1},'accuracy = %f');
        %iterloss = sscanf(o3{1},'Iteration %d, loss = %f');
        iter_top1(p_accuracy) = p*10;
        iter_accuracy(p_accuracy) = iter_accuracy_tmp(1);
        p_accuracy=p_accuracy+1;
    end
end;
fclose(fid);

%% plot
iter = iter(1:p-1);
loss = loss(1:p-1);
plot(iter,loss);
hold on
iter_top1 = iter_top1(1:p_accuracy-1);
iter_accuracy = iter_accuracy(1:p_accuracy-1);
plot(iter_top1,iter_accuracy);
legend('loss:15','accuracy:15');
title('Color training loss and accuracy(alexnet modified finetune 223)')
