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
        if strfind(raw_CESD{i,j},'���� �幰��/1�� ����')
            raw_CESD{i,j}=0;
        elseif strfind(raw_CESD{i,j},'����/1~2��')
            raw_CESD{i,j}=1;
        elseif strfind(raw_CESD{i,j},'����/3~4��')
            raw_CESD{i,j}=2;
        elseif strfind(raw_CESD{i,j},'���� ��κ�/5~7��')
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
        if strfind(raw_PANAS{i,j},'���� �׷��� �ʴ�(1)')
            raw_PANAS{i,j}=1;
        elseif strfind(raw_PANAS{i,j},'�ణ �׷���(2)')
            raw_PANAS{i,j}=2;
        elseif strfind(raw_PANAS{i,j},'���� �׷���(3)')
            raw_PANAS{i,j}=3;
        elseif strfind(raw_PANAS{i,j},'���� �׷���(4)')
            raw_PANAS{i,j}=4;
        elseif strfind(raw_PANAS{i,j},'�ſ� ���� �׷���(5)')
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
        if strfind(raw_STAIY2{i,j},'���� �׷��� �ʴ�(0)')
            raw_STAIY2{i,j}=0;
        elseif strfind(raw_STAIY2{i,j},'���� �׷���(1)')
            raw_STAIY2{i,j}=1;
        elseif strfind(raw_STAIY2{i,j},'�������� �׷���(2)')
            raw_STAIY2{i,j}=2;
        elseif strfind(raw_STAIY2{i,j},'����� �׷���(3)')
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
indxtext = {'1. ���� ����� ����.','2. ���� ���� �Ƿ�������.','3. ���� ��� ���� �����̴�.',...
    '4. ���� �ٸ� �����ó�� �ູ������ �Ѵ�.','5. ���� ������ ���� ������ ���ؼ� ���и� �Ѵ�.',...
    '6. ���� ������ ���δ�.','7. ���� ħ���ϰ� �����ϴ�.',...
    '8. ���� �ʹ� ���� ���� ������ �о���ļ� �غ��� �� ���� �� ����.',...
    '9. ���� ������ �Ͽ� �ʹ� ������ ���� �Ѵ�.','10. ���� �ູ�ϴ�.',...
    '11. ���� ���� ���̰� ����� �����Ѵ�.','12. ���� �ڽŰ��� �����ϴ�.',...
    '13. ���� ������ ����ϴ�.','14. ���� ���⳪ ������� ���Ϸ��� �־���.',...
    '15. ���� �����ϴ�.','16. ���� ����������.','17. ����� ������ ���� ��������.',...
    '18. ���� �Ǹ��� ����ġ�� �����ϰ� �޾Ƶ��̱� ������ �Ӹ��ӿ��� �������� ���� ����.',...
    '19. ���� ������ ����̴�.',...
    '20. ���� �������� �����̳� ���ɰŸ��� �����ϸ� ����ǰų� ������ �ٸ� �𸥴�.'};

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
        if strfind(raw_RRS{i,j},'���� ����(1)')
            raw_RRS{i,j}=1;
        elseif strfind(raw_RRS{i,j},'������(2)')
            raw_RRS{i,j}=2;
        elseif strfind(raw_RRS{i,j},'����(3)')
            raw_RRS{i,j}=3;
        elseif strfind(raw_RRS{i,j},'���� �׻�(4)')
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
indxtext = {'���� �󸶳� �ܷο����� ���� �����Ѵ�.',...
    '"�̷� ��п��� ���������� ���ϸ� ���� ���� ���� �ž�."��� �����Ѵ�',...
    '���� �󸶳� �Ƿ��ϰ� �������� ���� �����Ѵ�.',...
    '�����ϴ� ���� �󸶳� ����� ���� ���� �����Ѵ�.',...
    '"���� ���� ���� �߱⿡ �̷� ���� ���ұ�?"�ϰ� �����Ѵ�.',...
    '���� �󸶳� �������̰� �ǿ��� �������� ���� �����Ѵ�.',...
    '���� �� ����������� �˾Ƴ��� ���� �ֱ��� ��ǵ��� �м��Ѵ�.',...
    '���� �� �̻� �ƹ��͵� ���� �� ���� �͸� ���ٰ� �����Ѵ�.',...
    '"�� ���� ����ϰ� ������ ���ұ�?"�ϰ� �����Ѵ�.',...
    '"���� �� �׻� �̷� ������� �����ұ�" �����Ѵ�.',...
    'ȥ�� ������ �� ���� �̷��� ���������� ���� �����Ѵ�.',...
    '���� �����ϰ� �ִ� ���� �۷� ���� �м��� ����.',...
    '�ֱ��� ��Ȳ�� �� �������� ������ ���ϰ� �����Ѵ�.',...
    '"��� �̷������� ���� �ٰ��� �����ϴ°� ���� �ž�"��� �����Ѵ�.',...
    '"���� �� �ٸ� ����鿡�Դ� ���� ������ ������?" ��� �����Ѵ�.',...
    '"�� ���� ��Ȳ�� �� �� ��ó���� ���ұ�?" ��� �����Ѵ�.',...
    '���� �󸶳� �������� ���� �����Ѵ�.',...
    '���� ��� ������ ���е� �߸� �Ǽ��� ���� �����Ѵ�',...
    '�ƹ� �͵� �� ����� �� ��ٴ� ������ �Ѵ�',...
    '���� �� ����������� �����Ϸ��� ���� ������ �м��غ���',...
    'ȥ�� ���а� ���� �� ��п� ���� �����Ѵ�',...
    '���� �����ο��� �󸶳� ȭ�� �������� ���� �����Ѵ�.'};

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
        if strfind(raw_IPI{i,j},'�幰��')
            raw_IPI{i,j}=1;
        elseif strfind(raw_IPI{i,j},'�����Ͽ� �� ��')
            raw_IPI{i,j}=2;
        elseif strfind(raw_IPI{i,j},'�Ϸ翡 �� ��')
            raw_IPI{i,j}=3;
        elseif strfind(raw_IPI{i,j},'�Ϸ翡 �� ��')
            raw_IPI{i,j}=4;
        elseif strfind(raw_IPI{i,j},'�Ϸ翡 ���� �ð� ����')
            raw_IPI{i,j}=5;
        end
    end
end
j = 2;
for i = 1:size(raw_IPI,1)
    if strfind(raw_IPI{i,j},'����')
        raw_IPI{i,j}=1;
    elseif strfind(raw_IPI{i,j},'�幰��')
        raw_IPI{i,j}=2;
    elseif strfind(raw_IPI{i,j},'������')
        raw_IPI{i,j}=3;
    elseif strfind(raw_IPI{i,j},'����')
        raw_IPI{i,j}=4;
    elseif strfind(raw_IPI{i,j},'�׻�')
        raw_IPI{i,j}=5;
    end
end
j = 3;
for i = 1:size(raw_IPI,1)
    if strfind(raw_IPI{i,j},'������ ���� ���Ѵ�.')
        raw_IPI{i,j}=1;
    elseif strfind(raw_IPI{i,j},'���� ������ ���� �ʴ´�.')
        raw_IPI{i,j}=2;
    elseif strfind(raw_IPI{i,j},'���� �����ϴ� ������ �ִ�.')
        raw_IPI{i,j}=3;
    elseif strfind(raw_IPI{i,j},'������ �����ϴ� ������ �ִ�.')
        raw_IPI{i,j}=4;
    elseif strfind(raw_IPI{i,j},'�������� �����̴�.')
        raw_IPI{i,j}=5;
    end
end
j = 4;
for i = 1:size(raw_IPI,1)
    if strfind(raw_IPI{i,j},'��ü �ð��� 0%')
        raw_IPI{i,j}=1;
    elseif strfind(raw_IPI{i,j},'��ü �ð��� 10%')
        raw_IPI{i,j}=2;
    elseif strfind(raw_IPI{i,j},'��ü �ð��� 25%')
        raw_IPI{i,j}=3;
    elseif strfind(raw_IPI{i,j},'��ü �ð��� 50%')
        raw_IPI{i,j}=4;
    elseif strfind(raw_IPI{i,j},'��ü �ð��� 75%')
        raw_IPI{i,j}=5;
    end
end
j = 6;
for i = 1:size(raw_IPI,1)
    if strfind(raw_IPI{i,j},'����')
        raw_IPI{i,j}=1;
    elseif strfind(raw_IPI{i,j},'�幰��')
        raw_IPI{i,j}=2;
    elseif strfind(raw_IPI{i,j},'������')
        raw_IPI{i,j}=3;
    elseif strfind(raw_IPI{i,j},'����')
        raw_IPI{i,j}=4;
    elseif strfind(raw_IPI{i,j},'���� �ð� ����')
        raw_IPI{i,j}=5;
    end
end
j = 7;
for i = 1:size(raw_IPI,1)
    if strfind(raw_IPI{i,j},'�� �ð��� 0% ���� ����� ����.')
        raw_IPI{i,j}=1;
    elseif strfind(raw_IPI{i,j},'�� �ð��� 10% �̸� ���� ����� ����.')
        raw_IPI{i,j}=2;
    elseif strfind(raw_IPI{i,j},'�� �ð��� 10% ���� ����� ����.')
        raw_IPI{i,j}=3;
    elseif strfind(raw_IPI{i,j},'�� �ð��� 25% ���� ����� ����.')
        raw_IPI{i,j}=4;
    elseif strfind(raw_IPI{i,j},'�� �ð��� 50% ���� ����� ����.')
        raw_IPI{i,j}=5;
    end
end
j = 8;
for i = 1:size(raw_IPI,1)
    if strfind(raw_IPI{i,j},'����')
        raw_IPI{i,j}=1;
    elseif strfind(raw_IPI{i,j},'�幰��')
        raw_IPI{i,j}=2;
    elseif strfind(raw_IPI{i,j},'������')
        raw_IPI{i,j}=3;
    elseif strfind(raw_IPI{i,j},'����')
        raw_IPI{i,j}=4;
    elseif strfind(raw_IPI{i,j},'�׻�')
        raw_IPI{i,j}=5;
    end
end
j = 10;
for i = 1:size(raw_IPI,1)
    if strfind(raw_IPI{i,j},'�� ������ �Ϻκе� �������� �ʴ´�. (0%)')
        raw_IPI{i,j}=1;
    elseif strfind(raw_IPI{i,j},'�� ������ 10%�̸��� �����Ѵ�.')
        raw_IPI{i,j}=2;
    elseif strfind(raw_IPI{i,j},'�� ������ 10%��ŭ �����Ѵ�.')
        raw_IPI{i,j}=3;
    elseif strfind(raw_IPI{i,j},'�� ������ 25%��ŭ �����Ѵ�.')
        raw_IPI{i,j}=4;
    elseif strfind(raw_IPI{i,j},'�� ������ 50%��ŭ �����Ѵ�.')
        raw_IPI{i,j}=5;
    end
end
j = 11;
for i = 1:size(raw_IPI,1)
    if strfind(raw_IPI{i,j},'���� �����ִ� �ð��� 0%�� �����Ѵ�.')
        raw_IPI{i,j}=1;
    elseif strfind(raw_IPI{i,j},'���� �����ִ� �ð��� 10% �̸��� �����Ѵ�.')
        raw_IPI{i,j}=2;
    elseif strfind(raw_IPI{i,j},'���� �����ִ� �ð��� 10%�� �����Ѵ�.')
        raw_IPI{i,j}=3;
    elseif strfind(raw_IPI{i,j},'���� �����ִ� �ð��� 25%�� �����Ѵ�.')
        raw_IPI{i,j}=4;
    elseif strfind(raw_IPI{i,j},'���� �����ִ� �ð��� 50%�� �����Ѵ�.')
        raw_IPI{i,j}=5;
    end
end

% mind wandering
for i = 1:size(raw_IPI,1)
    for j=[13,14,20:23]
        if strfind(raw_IPI{i,j},'���� �ƴϴ�')
            raw_IPI{i,j}=1;
        elseif strfind(raw_IPI{i,j},'���� �׷��� �ʴ�')
            raw_IPI{i,j}=2;
        elseif strfind(raw_IPI{i,j},'���� �׷���')
            raw_IPI{i,j}=3;
        elseif strfind(raw_IPI{i,j},'�׷���')
            raw_IPI{i,j}=4;
        elseif strfind(raw_IPI{i,j},'�ſ� �׷���')
            raw_IPI{i,j}=5;
        end
    end
end
for i = 1:size(raw_IPI,1)
    for j=[15:19, 24]
        if strfind(raw_IPI{i,j},'���� �ƴϴ�')
            raw_IPI{i,j}=5;
        elseif strfind(raw_IPI{i,j},'���� �׷��� �ʴ�')
            raw_IPI{i,j}=4;
        elseif strfind(raw_IPI{i,j},'���� �׷���')
            raw_IPI{i,j}=3;
        elseif strfind(raw_IPI{i,j},'�׷���')
            raw_IPI{i,j}=2;
        elseif strfind(raw_IPI{i,j},'�ſ� �׷���')
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
        if strfind(raw_ERQ{i,j},'1 (���� �������� �ʴ´�)')
            raw_ERQ{i,j}=1;
        elseif strfind(raw_ERQ{i,j},'2')
            raw_ERQ{i,j}=2;
        elseif strfind(raw_ERQ{i,j},'3')
            raw_ERQ{i,j}=3;
        elseif strfind(raw_ERQ{i,j},'4 (�����̴�)')
            raw_ERQ{i,j}=4;
        elseif strfind(raw_ERQ{i,j},'5')
            raw_ERQ{i,j}=5;
        elseif strfind(raw_ERQ{i,j},'6')
            raw_ERQ{i,j}=6;
        elseif strfind(raw_ERQ{i,j},'7 (�������� �����Ѵ�)')
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
        if strfind(raw_STAIY1{i,j},'���� �׷��� �ʴ�')
            raw_STAIY1{i,j}=1;
        elseif strfind(raw_STAIY1{i,j},'���� �׷���')
            raw_STAIY1{i,j}=2;
        elseif strfind(raw_STAIY1{i,j},'�������� �׷���')
            raw_STAIY1{i,j}=3;
        elseif strfind(raw_STAIY1{i,j},'����� �׷���')
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
indxtext = {'���� ������ �����ϴ�.','���� ������ ����ϴ�.','���� �����ϰ� �ִ�.',...
    '���� ��ȸ������ �����ϴ�.','���� ������ ���ϴ�.','���� ��Ȳ�ؼ� ������ �ٸ� �𸣰ڴ�.',...
    '���� ������ ������ ������ �����ϰ� �ִ�.','���� ������ ���δ�.','���� �Ҿ��ϴ�.',...
    '���� ����ϰ� ������.','���� �ڽŰ��� �ִ�.','���� ¥��������.','���� ������ ���������ϴ�.',...
    '���� �ص��� ����Ǿ� �ִ�.','�� ������ ������ Ǯ�� Ǫ���ϴ�.','���� ����������.',...
    '���� �����ϰ� �ִ�.','���� ��еǾ� ��¿ �� �𸥴�.','���� ��̴�.','���� ����� ����.'};
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
        if strfind(raw_pwb{i,j},'���� �׷��� �ʴ�(1)')
            raw_pwb{i,j}=1;
        elseif strfind(raw_pwb{i,j},'���� �׷��� �ʴ�(2)')
            raw_pwb{i,j}=2;
        elseif strfind(raw_pwb{i,j},'�����̴�(3)')
            raw_pwb{i,j}=3;
        elseif strfind(raw_pwb{i,j},'�ణ �׷���(4)')
            raw_pwb{i,j}=4;
        elseif strfind(raw_pwb{i,j},'�ſ� �׷���(5)')
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
        if strfind(raw_SFMPQ{i,j},'���� ����(0)')
            raw_SFMPQ{i,j}=0;
        elseif strfind(raw_SFMPQ{i,j},'�ణ(1)')
            raw_SFMPQ{i,j}=1;
        elseif strfind(raw_SFMPQ{i,j},'�߰�(2)')
            raw_SFMPQ{i,j}=2;
        elseif strfind(raw_SFMPQ{i,j},'����(3)')
            raw_SFMPQ{i,j}=3;
        end
    end
end

% 68
for i=1:size(raw_SFMPQ,1)
    if strfind(raw_SFMPQ{i,end},'0 ���� ����')
        raw_SFMPQ{i,end}=0;
    elseif strfind(raw_SFMPQ{i,end},'1 ������ ����')
        raw_SFMPQ{i,end}=1;
    elseif strfind(raw_SFMPQ{i,end},'2 ������ ������ ����')
        raw_SFMPQ{i,end}=2;
    elseif strfind(raw_SFMPQ{i,end},'3 ���뽺���� ������ ����')
        raw_SFMPQ{i,end}=3;
    elseif strfind(raw_SFMPQ{i,end},'4 ������ ���� ����')
        raw_SFMPQ{i,end}=4;
    elseif strfind(raw_SFMPQ{i,end},'5 �� �̻� �ߵ�� ���� ����')
        raw_SFMPQ{i,end}=5;
    end
end

% 66��
SFsensation = cell2mat(raw_SFMPQ(2:end,1:11));
raw_SFMPQ(2:end,18) = num2cell(sum(SFsensation,2));
raw_SFMPQ{1,18} = '66��_Sensory Subscale';

SFemotion = cell2mat(raw_SFMPQ(2:end,12:15));
raw_SFMPQ(2:end,19) = num2cell(sum(SFemotion,2));
raw_SFMPQ{1,19} = '66��_Affective Subscale';

SFsubtotal = cell2mat(raw_SFMPQ(2:end,18:19));
raw_SFMPQ(2:end,20) = num2cell(sum(SFsubtotal,2));
raw_SFMPQ{1,20} = 'Overall Pain Experience';

% 67��
raw_SFMPQ(2:end,21) = raw_SFMPQ(2:end,16);
raw_SFMPQ{1,21} = '67��_Visual Analogue Scale';

% 68��
raw_SFMPQ(2:end,22) = raw_SFMPQ(2:end,17);
raw_SFMPQ{1,22} = '68��_Present Pain Intensity';

% Change Text
indxtext = {'��ŰŸ���','��� ����','Į�� ��� ����','��ī�ο� ����','���¥�� ����','������','Ÿ�� ����','������','������','�ΰ���','�������� ����','��ġ�� �������','�̽İŸ���','�η���','Ȥ���� ���� �޴� ����'};
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