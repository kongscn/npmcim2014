%% Import data from spreadsheet
% Script for importing data from the following spreadsheet:
%
%    Workbook: data/t2.xlsx Worksheet: Sheet1
%
% To extend the code for use with different selected data or a different
% spreadsheet, generate a function instead of a script.

%% Import the data
[~, ~, raw] = xlsread('data/t2.xlsx','Sheet1');
raw = raw(2:end,:);
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
t2 = reshape([raw{:}],size(raw));

%% Clear temporary variables
clearvars raw R;