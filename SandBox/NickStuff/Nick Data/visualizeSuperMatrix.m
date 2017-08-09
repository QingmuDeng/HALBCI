%This code will 
load('/home/gsteelman/Desktop/Summer Research/HALBCI/SandBox/NickStuff/Nick Data/superMatrix.mat')

hold on

if ~exist('allData','var')
   makesuperMatrix; 
end
plotSize = 60;
channels = {'P3','P4'};
selectedChannels = []
for i = 1: length(channels)
    index = find(strcmp(allData.channels,char(channels(i))))
    selectedChannels = [selectedChannels index]
end
natural = 1;
freq = 7.5;
freq2 = 12;
freq3 = 15;
freq4 = 20;
one = 0;
list1 = [];
list2 = [];
list3 = [];
list4 = [];
for i = 1:length(allData.attIndex)
   if allData.attIndex(i) == freq
      if length(channels) > 1 temp = squeeze(mean(allData.DataTCF(i,selectedChannels,6:plotSize)));
      else  temp =  squeeze(allData.DataTCF(i,selectedChannels,6:plotSize));end
      list1 = [list1;temp.'];
      one = one +1;
   end
    
end
one

for i = 1:length(allData.attIndex)
   if allData.attIndex(i) == freq2
      if length(channels) > 1 temp = squeeze(mean(allData.DataTCF(i,selectedChannels,6:plotSize)));
      else  temp =  squeeze(allData.DataTCF(i,selectedChannels,6:plotSize));end
      list2 = [list2;temp.'];   
   end
    
end

for i = 1:length(allData.attIndex)
   if allData.attIndex(i) == freq3
      if length(channels) > 1 temp = squeeze(mean(allData.DataTCF(i,selectedChannels,6:plotSize)));
      else  temp =  squeeze(allData.DataTCF(i,selectedChannels,6:plotSize)); end
      list3 = [list3;temp.'];  
   end
    
end

for i = 1:length(allData.attIndex)
   if allData.attIndex(i) == freq4
      if length(channels) > 1 temp = squeeze(mean(allData.DataTCF(i,selectedChannels,6:plotSize)));
      else  temp =  squeeze(allData.DataTCF(i,selectedChannels,6:plotSize)); end
      list4 = [list4;temp.'];  
   end
    
end
figure
meanAll = mean([mean(list1(:,:));mean(list2(:,:));mean(list3(:,:));mean(list4(:,:))]);
if natural 
    plotOne = mean(list1(:,:));
else
    plotOne = mean(list1(:,:))-meanAll;
    plotOne(plotOne<0) = 0
end
if natural 
    plotTwo = mean(list2(:,:));
else
    plotTwo = mean(list2(:,:))-meanAll;
    plotTwo(plotTwo<0) = 0
end
if natural 
    plotThree = mean(list3(:,:));
else
    plotThree = mean(list3(:,:))-meanAll;
    plotThree(plotThree<0) = 0
end
if natural
    plotFour = mean(list4(:,:));
else
    plotFour = mean(list4(:,:))-meanAll;
    plotFour(plotFour<0) = 0
end

plot(allData.freq(6:plotSize),plotOne,'b','LineWidth',2)
hold on
plot(allData.freq(6:plotSize),plotTwo,'g','LineWidth',2)
plot(allData.freq(6:plotSize),plotThree,'r','LineWidth',2)
plot(allData.freq(6:plotSize),plotFour,'k','LineWidth',2)
legend('7.5 Hz','12 Hz','15 Hz','20 Hz')
title('P7 and P8')
xlabel('Frequency (Hz)')
ylabel('Power')