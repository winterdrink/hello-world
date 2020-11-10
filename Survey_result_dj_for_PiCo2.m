%% PRESURVEY TOTAL DATA

[~,~,raw_once]= xlsread('PiCo2_pre_survey_1.xlsx');
[~,~,raw_multiple] = xlsread('PiCo2_pre_survey_2.xlsx');
Q = [];

idx.once = [89 106 size(raw_once,2)+1];
idx.once_names =  {'SMPQ'}; % 89-105
idx.multiple = [18 38 58 78 108 130 154 193 203 231 251 256 size(raw_multiple,2)+1];
idx.multiple_names = {'', 'CES-D', 'PANAS', 'STAI-Y2', '', 'K-RRS', 'IPI', '', 'ERQ', '', 'STAI-Y1', '', 'PWB'};

%% multi 1: CES-D
que_num = 1;
clear raw_CESD
raw_CESD(:,1:idx.multiple(que_num+1)-idx.multiple(que_num)) = raw_multiple(:,idx.multiple(que_num):idx.multiple(que_num+1)-1);

for i=1:size(raw_CESD,1)
    for j=1:size(raw_CESD,2)
        if strfind(raw_CESD{i,j},'극히 드물다/1일 이하')
            raw_CESD{i,j}=0;
        elseif strfind(raw_CESD{i,j},'가끔/1~2일')
            raw_CESD{i,j}=1;
        elseif strfind(raw_CESD{i,j},'자주/3~4일')
            raw_CESD{i,j}=2;
        elseif strfind(raw_CESD{i,j},'거의 대부분/5~7일')
            raw_CESD{i,j}=3;
        end
    end
end

% reverse index
revise_idx = [4 8 12 16];
temp = cell2mat(raw_CESD(2:end,:));
temp(:,revise_idx) = 3 - temp(:,revise_idx);

% Sum
raw_CESD(2:end,end+1) = num2cell(sum(temp,2));
raw_CESD{1,end} = 'Depression Scale';

% Fill structure
Q.CESD.total = raw_CESD;
Q.CESD.text(:,1) = raw_CESD(1,1:end-1)';
Q.CESD.text{1,2} = 'Depression Scale';
Q.CESD.data = temp;
Q.CESD.result = sum(temp,2);


%% multi 2: PANAS
que_num = 2;
clear raw_PANAS
raw_PANAS(:,1:idx.multiple(que_num+1)-idx.multiple(que_num)) = raw_multiple(:,idx.multiple(que_num):idx.multiple(que_num+1)-1);

for i=1:size(raw_PANAS,1)
    for j=1:size(raw_PANAS,2)
        if strfind(raw_PANAS{i,j},'전혀 그렇지 않다(1)')
            raw_PANAS{i,j}=1;
        elseif strfind(raw_PANAS{i,j},'약간 그렇다(2)')
            raw_PANAS{i,j}=2;
        elseif strfind(raw_PANAS{i,j},'보통 그렇다(3)')
            raw_PANAS{i,j}=3;
        elseif strfind(raw_PANAS{i,j},'많이 그렇다(4)')
            raw_PANAS{i,j}=4;
        elseif strfind(raw_PANAS{i,j},'매우 많이 그렇다(5)')
            raw_PANAS{i,j}=5;
        end
    end
end

% Sum
positive = cell2mat(raw_PANAS(2:end,[1,5,8,9,12,14,17,18,19]));
raw_PANAS(2:end,end+1) = num2cell(sum(positive,2));
raw_PANAS{1,end} = 'Positive Affect';

negative = cell2mat(raw_PANAS(2:end,[2:4,6,7,10,11,13,15,16,20]));
raw_PANAS(2:end,end+1) = num2cell(sum(negative,2));
raw_PANAS{1,end} = 'Negative Affect';

% Fill structure
Q.PANAS.total = raw_PANAS;
Q.PANAS.text(:,1) = raw_PANAS(1,1:end-2);
Q.PANAS.text(1:2,2) = raw_PANAS(1,end-1:end);
Q.PANAS.data = cell2mat(raw_PANAS(2:end, 1:end-2));
Q.PANAS.result = cell2mat(raw_PANAS(2:end, end-1:end));

%% multi 3: STAI-Y2 (STAIYT)
que_num = 3;
clear raw_STAIY2
raw_STAIY2(:,1:idx.multiple(que_num+1)-idx.multiple(que_num)) = raw_multiple(:,idx.multiple(que_num):idx.multiple(que_num+1)-1);

for i = 1:size(raw_STAIY2,1)
    for j = 1:size(raw_STAIY2,2)
        if strfind(raw_STAIY2{i,j},'전혀 그렇지 않다(0)')
            raw_STAIY2{i,j}=0;
        elseif strfind(raw_STAIY2{i,j},'조금 그렇다(1)')
            raw_STAIY2{i,j}=1;
        elseif strfind(raw_STAIY2{i,j},'보통으로 그렇다(2)')
            raw_STAIY2{i,j}=2;
        elseif strfind(raw_STAIY2{i,j},'대단히 그렇다(3)')
            raw_STAIY2{i,j}=3;
        end
    end
end

revise_idx = [1,6,7,10,13,16,19];
temp = cell2mat(raw_STAIY2(2:end,:));
temp(:,revise_idx) = 3 - temp(:,revise_idx);

% Sum
raw_STAIY2(2:end,end+1) = num2cell(sum(temp,2));
raw_STAIY2{1,end} = 'Trait Anxiety Scale';

% Change Text
indxtext = {'1. 나는 기분이 좋다.','2. 나는 쉽게 피로해진다.','3. 나는 울고 싶은 심정이다.',...
    '4. 나는 다른 사람들처럼 행복했으면 한다.','5. 나는 마음을 빨리 정하지 못해서 실패를 한다.',...
    '6. 나는 마음이 놓인다.','7. 나는 침착하고 차분하다.',...
    '8. 나는 너무 많은 여러 문제가 밀어닥쳐서 극복할 수 없을 것 같다.',...
    '9. 나는 하찮은 일에 너무 걱정을 많이 한다.','10. 나는 행복하다.',...
    '11. 나는 무슨 일이건 힘들게 생각한다.','12. 나는 자신감이 부족하다.',...
    '13. 나는 마음이 든든하다.','14. 나는 위기나 어려움을 피하려고 애쓴다.',...
    '15. 나는 울적하다.','16. 나는 만족스럽다.','17. 사소한 생각이 나를 괴롭힌다.',...
    '18. 나는 실망을 지나치게 예민하게 받아들이기 때문에 머릿속에서 지워버릴 수가 없다.',...
    '19. 나는 착실한 사람이다.',...
    '20. 나는 요즈음의 걱정이나 관심거리를 생각하면 긴장되거나 어찌할 바를 모른다.'};

% Fill structure
Q.STAIYT.total = raw_STAIY2;
Q.STAIYT.text = indxtext';
Q.STAIYT.text{1,2} = 'Trait Anxiety Scale';
Q.STAIYT.data = temp;
Q.STAIYT.result = sum(temp,2);

%% multi 5: RRS
que_num = 5;
clear raw_RRS
raw_RRS(:,1:idx.multiple(que_num+1)-idx.multiple(que_num)) = raw_multiple(:,idx.multiple(que_num):idx.multiple(que_num+1)-1);

for i=1:size(raw_RRS,1)
    for j=1:size(raw_RRS,2)
        if strfind(raw_RRS{i,j},'거의 전혀(1)')
            raw_RRS{i,j}=1;
        elseif strfind(raw_RRS{i,j},'가끔씩(2)')
            raw_RRS{i,j}=2;
        elseif strfind(raw_RRS{i,j},'종종(3)')
            raw_RRS{i,j}=3;
        elseif strfind(raw_RRS{i,j},'거의 항상(4)')
            raw_RRS{i,j}=4;
        end
    end
end

% Sum
Brooding = cell2mat(raw_RRS(2:end,[5,9,10,13,15,16,18]));
raw_RRS(2:end,end+1) = num2cell(sum(Brooding,2));
raw_RRS{1,end} = 'Brooding Factor';

Pondering = cell2mat(raw_RRS(2:end,[7,11,12,20,21,22]));
raw_RRS(2:end,end+1) = num2cell(sum(Pondering,2));
raw_RRS{1,end} = 'Reflective Pondering Factor';

Depressive = cell2mat(raw_RRS(2:end,[1:4,6,8,14,17,19]));
raw_RRS(2:end,end+1) = num2cell(sum(Depressive,2));
raw_RRS{1,end} = 'Depressive Rumination Factor';

TotalRRS = cell2mat(raw_RRS(2:end,23:25));
raw_RRS(2:end,end+1) = num2cell(sum(TotalRRS,2));
raw_RRS{1,end} = 'Total Score';

% Change Text
indxtext = {'내가 얼마나 외로운지에 대해 생각한다.',...
    '"이런 기분에서 빠져나오지 못하면 일을 하지 못할 거야."라고 생각한다',...
    '내가 얼마나 피로하고 아픈지에 대해 생각한다.',...
    '집중하는 것이 얼마나 어려운 지에 대해 생각한다.',...
    '"내가 무슨 일을 했기에 이런 일을 당할까?"하고 생각한다.',...
    '내가 얼마나 수동적이고 의욕이 없는지에 대해 생각한다.',...
    '내가 왜 우울해졌는지 알아내기 위해 최근의 사건들을 분석한다.',...
    '이제 더 이상 아무것도 느낄 수 없을 것만 같다고 생각한다.',...
    '"왜 나는 꿋꿋하게 지내지 못할까?"하고 생각한다.',...
    '"나는 왜 항상 이런 방식으로 반응할까" 생각한다.',...
    '혼자 조용히 왜 내가 이렇게 느끼는지에 대해 생각한다.',...
    '내가 생각하고 있는 것을 글로 쓰고 분석해 본다.',...
    '최근의 상황이 더 나았으면 좋았을 걸하고 생각한다.',...
    '"계속 이런식으로 느끼 다가는 집중하는게 힘들 거야"라고 생각한다.',...
    '"나는 왜 다른 사람들에게는 없는 문제가 있을까?" 라고 생각한다.',...
    '"왜 나는 상황을 더 잘 대처하지 못할까?" 라고 생각한다.',...
    '내가 얼마나 슬픈지에 대해 생각한다.',...
    '나의 모든 단점과 실패들 잘못 실수에 대해 생각한다',...
    '아무 것도 할 기분이 안 든다는 생각을 한다',...
    '내가 왜 우울해졌는지 이해하려고 나의 성격을 분석해본다',...
    '혼자 어디론가 가서 내 기분에 대해 생각한다',...
    '내가 스스로에게 얼마나 화가 났는지에 대해 생각한다.'};

% Fill structure
Q.RRS.total = raw_RRS;
Q.RRS.text = indxtext';
Q.RRS.text(1:4,2) = raw_RRS(1,23:26);
Q.RRS.data = cell2mat(raw_RRS(2:end,1:end-4));
Q.RRS.result = cell2mat(raw_RRS(2:end,end-3:end));

%% multi 6: IPI
que_num = 6;
clear raw_IPI
raw_IPI(:,1:idx.multiple(que_num+1)-idx.multiple(que_num)) = raw_multiple(:,idx.multiple(que_num):idx.multiple(que_num+1)-1);

% Frequency Scale
for i=1:size(raw_IPI,1)
    for j=[1,5,9,12]
        if strfind(raw_IPI{i,j},'드물게')
            raw_IPI{i,j}=1;
        elseif strfind(raw_IPI{i,j},'일주일에 한 번')
            raw_IPI{i,j}=2;
        elseif strfind(raw_IPI{i,j},'하루에 한 번')
            raw_IPI{i,j}=3;
        elseif strfind(raw_IPI{i,j},'하루에 몇 번')
            raw_IPI{i,j}=4;
        elseif strfind(raw_IPI{i,j},'하루에 많은 시간 동안')
            raw_IPI{i,j}=5;
        end
    end
end
j = 2;
for i = 1:size(raw_IPI,1)
    if strfind(raw_IPI{i,j},'절대')
        raw_IPI{i,j}=1;
    elseif strfind(raw_IPI{i,j},'드물게')
        raw_IPI{i,j}=2;
    elseif strfind(raw_IPI{i,j},'가끔씩')
        raw_IPI{i,j}=3;
    elseif strfind(raw_IPI{i,j},'자주')
        raw_IPI{i,j}=4;
    elseif strfind(raw_IPI{i,j},'항상')
        raw_IPI{i,j}=5;
    end
end
j = 3;
for i = 1:size(raw_IPI,1)
    if strfind(raw_IPI{i,j},'공상을 전혀 안한다.')
        raw_IPI{i,j}=1;
    elseif strfind(raw_IPI{i,j},'거의 공상을 하지 않는다.')
        raw_IPI{i,j}=2;
    elseif strfind(raw_IPI{i,j},'가끔 공상하는 경향이 있다.')
        raw_IPI{i,j}=3;
    elseif strfind(raw_IPI{i,j},'적당히 공상하는 경향이 있다.')
        raw_IPI{i,j}=4;
    elseif strfind(raw_IPI{i,j},'습관적인 공상가이다.')
        raw_IPI{i,j}=5;
    end
end
j = 4;
for i = 1:size(raw_IPI,1)
    if strfind(raw_IPI{i,j},'전체 시간의 0%')
        raw_IPI{i,j}=1;
    elseif strfind(raw_IPI{i,j},'전체 시간의 10%')
        raw_IPI{i,j}=2;
    elseif strfind(raw_IPI{i,j},'전체 시간의 25%')
        raw_IPI{i,j}=3;
    elseif strfind(raw_IPI{i,j},'전체 시간의 50%')
        raw_IPI{i,j}=4;
    elseif strfind(raw_IPI{i,j},'전체 시간의 75%')
        raw_IPI{i,j}=5;
    end
end
j = 6;
for i = 1:size(raw_IPI,1)
    if strfind(raw_IPI{i,j},'전혀')
        raw_IPI{i,j}=1;
    elseif strfind(raw_IPI{i,j},'드물게')
        raw_IPI{i,j}=2;
    elseif strfind(raw_IPI{i,j},'가끔씩')
        raw_IPI{i,j}=3;
    elseif strfind(raw_IPI{i,j},'자주')
        raw_IPI{i,j}=4;
    elseif strfind(raw_IPI{i,j},'많은 시간 동안')
        raw_IPI{i,j}=5;
    end
end
j = 7;
for i = 1:size(raw_IPI,1)
    if strfind(raw_IPI{i,j},'내 시간의 0% 동안 사색에 잠긴다.')
        raw_IPI{i,j}=1;
    elseif strfind(raw_IPI{i,j},'내 시간의 10% 미만 동안 사색에 잠긴다.')
        raw_IPI{i,j}=2;
    elseif strfind(raw_IPI{i,j},'내 시간의 10% 동안 사색에 잠긴다.')
        raw_IPI{i,j}=3;
    elseif strfind(raw_IPI{i,j},'내 시간의 25% 동안 사색에 잠긴다.')
        raw_IPI{i,j}=4;
    elseif strfind(raw_IPI{i,j},'내 시간의 50% 동안 사색에 잠긴다.')
        raw_IPI{i,j}=5;
    end
end
j = 8;
for i = 1:size(raw_IPI,1)
    if strfind(raw_IPI{i,j},'전혀')
        raw_IPI{i,j}=1;
    elseif strfind(raw_IPI{i,j},'드물게')
        raw_IPI{i,j}=2;
    elseif strfind(raw_IPI{i,j},'가끔씩')
        raw_IPI{i,j}=3;
    elseif strfind(raw_IPI{i,j},'자주')
        raw_IPI{i,j}=4;
    elseif strfind(raw_IPI{i,j},'항상')
        raw_IPI{i,j}=5;
    end
end
j = 10;
for i = 1:size(raw_IPI,1)
    if strfind(raw_IPI{i,j},'내 생각의 일부분도 차지하지 않는다. (0%)')
        raw_IPI{i,j}=1;
    elseif strfind(raw_IPI{i,j},'내 생각의 10%미만을 차지한다.')
        raw_IPI{i,j}=2;
    elseif strfind(raw_IPI{i,j},'내 생각의 10%만큼 차지한다.')
        raw_IPI{i,j}=3;
    elseif strfind(raw_IPI{i,j},'내 생각의 25%만큼 차지한다.')
        raw_IPI{i,j}=4;
    elseif strfind(raw_IPI{i,j},'내 생각의 50%만큼 차지한다.')
        raw_IPI{i,j}=5;
    end
end
j = 11;
for i = 1:size(raw_IPI,1)
    if strfind(raw_IPI{i,j},'내가 깨어있는 시간의 0%를 차지한다.')
        raw_IPI{i,j}=1;
    elseif strfind(raw_IPI{i,j},'내가 깨어있는 시간의 10% 미만을 차지한다.')
        raw_IPI{i,j}=2;
    elseif strfind(raw_IPI{i,j},'내가 깨어있는 시간의 10%를 차지한다.')
        raw_IPI{i,j}=3;
    elseif strfind(raw_IPI{i,j},'내가 깨어있는 시간의 25%를 차지한다.')
        raw_IPI{i,j}=4;
    elseif strfind(raw_IPI{i,j},'내가 깨어있는 시간의 50%를 차지한다.')
        raw_IPI{i,j}=5;
    end
end

% mind wandering
for i = 1:size(raw_IPI,1)
    for j=[13,14,20:23]
        if strfind(raw_IPI{i,j},'전혀 아니다')
            raw_IPI{i,j}=1;
        elseif strfind(raw_IPI{i,j},'보통 그렇지 않다')
            raw_IPI{i,j}=2;
        elseif strfind(raw_IPI{i,j},'보통 그렇다')
            raw_IPI{i,j}=3;
        elseif strfind(raw_IPI{i,j},'그렇다')
            raw_IPI{i,j}=4;
        elseif strfind(raw_IPI{i,j},'매우 그렇다')
            raw_IPI{i,j}=5;
        end
    end
end
for i = 1:size(raw_IPI,1)
    for j=[15:19, 24]
        if strfind(raw_IPI{i,j},'전혀 아니다')
            raw_IPI{i,j}=5;
        elseif strfind(raw_IPI{i,j},'보통 그렇지 않다')
            raw_IPI{i,j}=4;
        elseif strfind(raw_IPI{i,j},'보통 그렇다')
            raw_IPI{i,j}=3;
        elseif strfind(raw_IPI{i,j},'그렇다')
            raw_IPI{i,j}=2;
        elseif strfind(raw_IPI{i,j},'매우 그렇다')
            raw_IPI{i,j}=1;
        end
    end
end

% Sum
Frequency = cell2mat(raw_IPI(2:end,1:12));
raw_IPI(2:end,end+1) = num2cell(sum(Frequency,2));
raw_IPI{1,end}='Frequency Scale';

Mindwandering = cell2mat(raw_IPI(2:end,13:24));
raw_IPI(2:end,end+1) = num2cell(sum(Mindwandering,2));
raw_IPI{1,end}='Mind Wandering Scale';

% Fill structure
Q.IPI.total = raw_IPI;
Q.IPI.text(:,1) = raw_IPI(1,1:24)';
Q.IPI.text(1:2,2) = raw_IPI(1,25:end)';
Q.IPI.data = cell2mat(raw_IPI(2:end, 1:end-2));
Q.IPI.result = cell2mat(raw_IPI(2:end, end-1:end));

%% multi 8: ERQ
que_num = 8;
clear raw_ERQ
raw_ERQ(:,1:idx.multiple(que_num+1)-idx.multiple(que_num)) = raw_multiple(:,idx.multiple(que_num):idx.multiple(que_num+1)-1);

for i=1:size(raw_ERQ,1)
    for j=1:size(raw_ERQ,2)
        if strfind(raw_ERQ{i,j},'1 (전혀 동의하지 않는다)')
            raw_ERQ{i,j}=1;
        elseif strfind(raw_ERQ{i,j},'2')
            raw_ERQ{i,j}=2;
        elseif strfind(raw_ERQ{i,j},'3')
            raw_ERQ{i,j}=3;
        elseif strfind(raw_ERQ{i,j},'4 (보통이다)')
            raw_ERQ{i,j}=4;
        elseif strfind(raw_ERQ{i,j},'5')
            raw_ERQ{i,j}=5;
        elseif strfind(raw_ERQ{i,j},'6')
            raw_ERQ{i,j}=6;
        elseif strfind(raw_ERQ{i,j},'7 (전적으로 동의한다)')
            raw_ERQ{i,j}=7;
        end
    end
end


% Sum
Cognitive = cell2mat(raw_ERQ(2:end,[1,3,5,7,8,10]));
raw_ERQ(2:end,end+1) = num2cell(sum(Cognitive,2));
raw_ERQ{1,end}='Cognitive Reappraisal Strategy';

Expression = cell2mat(raw_ERQ(2:end,[2,4,6,9]));
raw_ERQ(2:end,end+1) = num2cell(sum(Expression,2));
raw_ERQ{1,end}='Expressive Suppression Strategy';

TotalERQ = cell2mat(raw_ERQ(2:end,11:12));
raw_ERQ(2:end,end+1) = num2cell(sum(TotalERQ,2));
raw_ERQ{1,end}='Total Emotional Regulation Score';

% Fill structure
Q.ERQ.total = raw_ERQ;
Q.ERQ.text(:,1) = raw_ERQ(1,1:end-3)';
Q.ERQ.text(1:3,2) = raw_ERQ(1,end-2:end)';
Q.ERQ.data = cell2mat(raw_ERQ(2:end, 1:end-3));
Q.ERQ.result = cell2mat(raw_ERQ(2:end,end-2:end));

%% multi 10: STAI-Y1 (STAIYS)
que_num = 10;
clear raw_STAIY1
raw_STAIY1(:,1:idx.multiple(que_num+1)-idx.multiple(que_num)) = raw_multiple(:,idx.multiple(que_num):idx.multiple(que_num+1)-1);

for i=1:size(raw_STAIY1,1)
    for j=1:size(raw_STAIY1,2)
        if strfind(raw_STAIY1{i,j},'전혀 그렇지 않다')
            raw_STAIY1{i,j}=1;
        elseif strfind(raw_STAIY1{i,j},'조금 그렇다')
            raw_STAIY1{i,j}=2;
        elseif strfind(raw_STAIY1{i,j},'보통으로 그렇다')
            raw_STAIY1{i,j}=3;
        elseif strfind(raw_STAIY1{i,j},'대단히 그렇다')
            raw_STAIY1{i,j}=4;
        end
    end
end

% reverse index
revise_idx = [1,2,5,8,10,11,15,16,19,20];
temp = cell2mat(raw_STAIY1(2:end,:));
temp(:,revise_idx) = 5 - temp(:,revise_idx);

% Sum
raw_STAIY1(2:end,end+1) = num2cell(sum(temp,2));
raw_STAIY1{1,end} = 'State Anxiety Scale';

% Change Text
indxtext = {'나는 마음이 차분하다.','나는 마음이 든든하다.','나는 긴장하고 있다.',...
    '나는 후회스럽고 서운하다.','나는 마음이 편하다.','나는 당황해서 어찌할 바를 모르겠다.',...
    '나는 앞으로 불행이 있을까 걱정하고 있다.','나는 마음이 놓인다.','나는 불안하다.',...
    '나는 편안하게 느낀다.','나는 자신감이 있다.','나는 짜증스럽다.','나는 마음이 조마조마하다.',...
    '나는 극도로 긴장되어 있다.','내 마음은 긴장이 풀려 푸근하다.','나는 만족스럽다.',...
    '나는 걱정하고 있다.','나는 흥분되어 어쩔 줄 모른다.','나는 즐겁다.','나는 기분이 좋다.'};
raw_STAIY1(1,1:numel(indxtext)) = indxtext;

% Fill structure
Q.STAIYS.total = raw_STAIY1;
Q.STAIYS.text(:,1) = raw_STAIY1(1,1:end-1)';
Q.STAIYS.text(1,2) = raw_STAIY1(1,end)';
Q.STAIYS.data = temp;
Q.STAIYS.result = sum(temp,2);



%% multi 12: PWB
que_num = 12;
clear raw_pwb
raw_pwb(:,1:idx.multiple(que_num+1)-idx.multiple(que_num)) = raw_multiple(:,idx.multiple(que_num):idx.multiple(que_num+1)-1);

for i=1:size(raw_pwb,1)
    for j=1:size(raw_pwb,2)
        if strfind(raw_pwb{i,j},'전혀 그렇지 않다(1)')
            raw_pwb{i,j}=1;
        elseif strfind(raw_pwb{i,j},'별로 그렇지 않다(2)')
            raw_pwb{i,j}=2;
        elseif strfind(raw_pwb{i,j},'보통이다(3)')
            raw_pwb{i,j}=3;
        elseif strfind(raw_pwb{i,j},'약간 그렇다(4)')
            raw_pwb{i,j}=4;
        elseif strfind(raw_pwb{i,j},'매우 그렇다(5)')
            raw_pwb{i,j}=5;
        end
    end
end

revise_idx = [1 3 6 7 12 13 17 18];
temp = cell2mat(raw_pwb(2:end,:));
temp(:,revise_idx) = 6 - temp(:,revise_idx);

raw_pwb(2:end,end+1) = num2cell(sum(temp(:,1:3),2));
raw_pwb{1,end} = 'positive relations with others';
raw_pwb(2:end,end+1) = num2cell(sum(temp(:,4:6),2));
raw_pwb{1,end} = 'self acceptance';
raw_pwb(2:end,end+1) = num2cell(sum(temp(:,7:9),2));
raw_pwb{1,end} = 'autonomy';
raw_pwb(2:end,end+1) = num2cell(sum(temp(:,10:12),2));
raw_pwb{1,end} = 'personal growth';
raw_pwb(2:end,end+1) = num2cell(sum(temp(:,13:15),2));
raw_pwb{1,end} = 'environmental mastery';
raw_pwb(2:end,end+1) = num2cell(sum(temp(:,16:18),2));
raw_pwb{1,end} = 'purpose in life';
raw_pwb(2:end,end+1) = num2cell(sum(temp,2));
raw_pwb{1,end} = 'total';

% Fill structure
Q.PWB.total = raw_pwb;
Q.PWB.text(:,1) = raw_pwb(1,1:size(temp,2))';
Q.PWB.text(1:7,2) = raw_pwb(1,size(temp,2)+1:end)';
Q.PWB.data = temp;
Q.PWB.result = cell2mat(raw_pwb(2:end, size(temp,2)+1:end));

%% only 1: SMPQ
que_num = 1;
clear raw_SFMPQ
raw_SFMPQ(:,1:idx.once(que_num+1)-idx.once(que_num)) = raw_once(:,idx.once(que_num):idx.once(que_num+1)-1);

% 66,67
for i=1:size(raw_SFMPQ,1)
    for j=1:size(raw_SFMPQ,2)
        if strfind(raw_SFMPQ{i,j},'통증 없음(0)')
            raw_SFMPQ{i,j}=0;
        elseif strfind(raw_SFMPQ{i,j},'약간(1)')
            raw_SFMPQ{i,j}=1;
        elseif strfind(raw_SFMPQ{i,j},'중간(2)')
            raw_SFMPQ{i,j}=2;
        elseif strfind(raw_SFMPQ{i,j},'심한(3)')
            raw_SFMPQ{i,j}=3;
        end
    end
end

% 68
for i=1:size(raw_SFMPQ,1)
    if strfind(raw_SFMPQ{i,end},'0 통증 없음')
        raw_SFMPQ{i,end}=0;
    elseif strfind(raw_SFMPQ{i,end},'1 가벼운 통증')
        raw_SFMPQ{i,end}=1;
    elseif strfind(raw_SFMPQ{i,end},'2 불편한 정도의 통증')
        raw_SFMPQ{i,end}=2;
    elseif strfind(raw_SFMPQ{i,end},'3 고통스러운 정도의 통증')
        raw_SFMPQ{i,end}=3;
    elseif strfind(raw_SFMPQ{i,end},'4 무섭게 심한 통증')
        raw_SFMPQ{i,end}=4;
    elseif strfind(raw_SFMPQ{i,end},'5 더 이상 견디기 힘든 통증')
        raw_SFMPQ{i,end}=5;
    end
end

% 66번
SFsensation = cell2mat(raw_SFMPQ(2:end,1:11));
raw_SFMPQ(2:end,18) = num2cell(sum(SFsensation,2));
raw_SFMPQ{1,18} = '66번_Sensory Subscale';

SFemotion = cell2mat(raw_SFMPQ(2:end,12:15));
raw_SFMPQ(2:end,19) = num2cell(sum(SFemotion,2));
raw_SFMPQ{1,19} = '66번_Affective Subscale';

SFsubtotal = cell2mat(raw_SFMPQ(2:end,18:19));
raw_SFMPQ(2:end,20) = num2cell(sum(SFsubtotal,2));
raw_SFMPQ{1,20} = 'Overall Pain Experience';

% 67번
raw_SFMPQ(2:end,21) = raw_SFMPQ(2:end,16);
raw_SFMPQ{1,21} = '67번_Visual Analogue Scale';

% 68번
raw_SFMPQ(2:end,22) = raw_SFMPQ(2:end,17);
raw_SFMPQ{1,22} = '68번_Present Pain Intensity';

% Change Text
indxtext = {'욱신거리는','쏘는 듯한','칼로 찌르는 듯한','날카로운 듯한','쥐어짜는 듯한','성가진','타는 듯한','따가운','묵직한','민감한','찢어지는 듯한','지치고 무기력한','미식거리는','두려운','혹독한 벌을 받는 듯한'};
raw_SFMPQ(1,1:numel(indxtext)) = indxtext;

% Fill structure
Q.SFMPQ.total = raw_SFMPQ;
Q.SFMPQ.text(:,1) = raw_SFMPQ(1,1:17);
Q.SFMPQ.text(1:5,2) = raw_SFMPQ(1,18:end);
Q.SFMPQ.data = cell2mat(raw_SFMPQ(2:end,1:17));
Q.SFMPQ.result = cell2mat(raw_SFMPQ(2:end,18:end));


%%
clear raw* FPQ* Mindw* CESD* *_cell Pondering Total* SF*

%% SAVE
savedir = pwd; 
savename = fullfile(savedir, 'PiCo2_questionnaire.mat');
save(savename, 'Q');