clear

% Read in anonymous functions from JSON file
% All anonymous functions take the same input arguments: an array of
% coefficients, temperature, salinity and ionic strength
K_functions_file = jsondecode(fileread("./K_functions.json"));
K_functions_names = fieldnames(K_functions_file);

% Create an empty map
K_dictionary = containers.Map();

% Iterate over K's and assign to map
for K_index = 1:numel(K_functions_names)
    K_dictionary(string(K_functions_names{K_index})) = str2func(K_functions_file.(K_functions_names{K_index}));
end

clearvars K_functions_file K_functions_names K_index
