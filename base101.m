%%
%%%%%%%%%%%
%% Base Material Allowable Curves Visualization
% This MATLAB script visualizes allowable curves for base materials
% according to Publication 101.
% Key features:
% - Select different material types interactively page 390/844 tabe 1-13 Publication 101
% - Plot mesh sizes vs. lab values with shaded areas
% - Accept lab values via dialog input
% help
% Developed by Moin Asgharzadeh, Civil Engineer
% moin.asgharzade@gmail.com

%% clear
clc
clear ALL
close all
%% help
h = helpdlg([ ...
    'Welcome to the Base Material Allowable Curves Tool.' newline ...
    newline ...
    'Instructions:' newline ...
    '1. Select a base material type (Type 1 to Type 5) according to Table 1-13, Publication 101.' newline ...
    '2. Enter the lab-tested mesh-passed values for the selected type in the dialog box.' newline ...
    '3. Leave any entry blank if you do not have a value.' newline ...
    newline ...
    'Developed by Moin Asgharzadeh, Civil Engineer' newline ...
    'Email: moin.asgharzade@gmail.com'], 'Instructions');


uiwait(h);  % Wait until user closes the help dialog


%% chose tape
% Cases = ["I_min";"I_max";"II_min";"II_max";"III_min";"III_max";"IV_min";"IV_max";"V_min";"V_max"];
choice = menu('Select Type', 'Type 1', 'Type 2', 'Type 3', 'Type 4', 'Type 5');


if choice == 0
    disp('User canceled.');
    return
end

type = choice;

%%

mesh_size = [.075 0.425 0.6 2 4.75 9.5 19 25 37.5 50];

limits =[2	NaN	12	NaN	35	50	70	60	95	100
    8	NaN	25	NaN	55	70	92	80	100	100
    2   8  NaN 15  25  30  60  70  NaN 100
    8	20	NaN	40	55	65	80	85	NaN	100
    2	15	NaN	20	30	40	NaN	75	NaN	100
    8	30	NaN	45	60	75	NaN	95	NaN	100
    2	10	NaN	20	30	45	60	70	100	NaN
    8	30	NaN	50	60	75	90	100	100	NaN
    2	15	NaN	25	35	50	NaN	100	NaN	NaN
    8	30	NaN	50	65	85	NaN	100	NaN	NaN]




%% plot base type
colors = lines(floor(size(limits ,1)/2));

c = 1;

hold on
i=1
for i = type*2-1
    row1 = limits (i  ,:);
    row2 = limits (i+1,:);

    idx = ~isnan(row1)
    x  = mesh_size(idx);
    y1 = row1(idx);
    y2 = row2(idx);


    fill([x fliplr(x)], [y1 fliplr(y2)], colors(c,:), ...
        'FaceAlpha',0.25,'EdgeColor','none');


    plot(x, y1, 'o-','Color',colors(c,:),'LineWidth',1.5)
    plot(x, y2, 'o-','Color',colors(c,:),'LineWidth',1.5)

    c = c + 1;

end

set(gca, 'XScale', 'log')
grid on
xticks([.075 0.425 0.6 2 4.75 9.5 19 25 37.5 50])
xtickangle(45)

line2 = {'#200','#40','#30','#10','#4','3/8"','3/4"','1"','1 1/2"','2"'};

y_min = min(ylim);
y_offset = (max(ylim)-min(ylim))*-0.05;

for k = 1:length(mesh_size)
    text(mesh_size(k), y_min + y_offset, { line2{k}}, ...
        'HorizontalAlignment','center', ...
        'VerticalAlignment','top' , 'Rotation', 45)
end
ax = gca;
ax.FontSize = 10;
xtickangle(45)

title(['Base Material Allowable Curves – Selected Type: Type ' num2str(type)]);



%% input lab valu

n = length(mesh_size);
mesh_text = {'#200', '#40', '#30', '#10', '#4', '3/8"', '3/4"', '1"', '1 1/2"', '2"'};
prompt = cell(1,n);
default = cell(1,n);
for k = 1:n
    prompt{k} = ['Enter lab value for mesh size ' num2str(mesh_size(k)) ' mm ' ...
        ' (' mesh_text{k} '):'];     default{k} = ''
end

answer = inputdlg(prompt, 'Lab Values', [1 50], default);


lab_value = nan(1,n);
for k = 1:n
    if ~isempty(answer{k})
        lab_value(k) = str2double(answer{k});
    end
end

%% plot lab valu

idx = ~isnan(lab_value)
x  = mesh_size(idx);
yl = lab_value(idx);

plot(x, yl, 'o-','Color',colors(c,:),'LineWidth',1.5)

%% plot tabe


x_lab = mesh_size(idx);
y_lab = lab_value(idx);
mesh_text_valid = mesh_text(idx);

table_text = sprintf('Mesh | Lab Value\n');
for k = 1:length(x_lab)
    table_text = [table_text, sprintf('%5s | %5.1f\n', mesh_text_valid{k}, y_lab(k))];
end

x_pos = max(mesh_size) * 0.6;
y_pos = max(ylim) * 0.35;

text(x_pos, y_pos, table_text, ...
    'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', 'w', ...
    'EdgeColor', 'k', 'Margin', 5, 'VerticalAlignment','top');


%%