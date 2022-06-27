% fundamental_constants = jsondecode(fileread("./../coefficients/fundamental_constants.json"));

check_values = jsondecode(fileread("./../check_values/check_Ks.json"));
pressure_check_values = jsondecode(fileread("./../check_values/check_presscorr.json"));

temperature = check_values.input_conditions.TC;
salinity = check_values.input_conditions.S;
ionic_strength = (19.924.*salinity)./(1000-1.005.*salinity); % see Dickson 2007

pressure = pressure_check_values.input_conditions.P;

tolerance = 1;

%% Modern surface K's
tolerance = 1e-2;
K_output = kgen.kgen_static.calculate_all_Ks(temperature,salinity,NaN,NaN,NaN);
K_names = string(fieldnames(K_output));

% Iterate over K's to calculate value + difference from check value
for K_index = 1:numel(K_names)
    current_check_value = check_values.check_values.(K_names(K_index));
    K_difference.(K_names(K_index)) = log(K_output.(K_names(K_index)))-current_check_value;

    assert(abs(K_difference.(K_names(K_index)))<tolerance,"Modern surface "+K_names(K_index)+" mismatch")
end


%% Modern deep K's
tolerance = 1e-3;
[~,K_pressure_correction,~] = kgen.kgen_static.calculate_all_Ks(temperature,salinity,pressure,NaN,NaN);
K_names = string(fieldnames(K_pressure_correction));

% Iterate over K's to calculate value at depth + difference from check value
for K_index = 1:numel(K_names)
    current_check_value = pressure_check_values.check_values.(K_names(K_index));
    K_pressure_difference.(K_names(K_index)) = K_pressure_correction.(K_names(K_index))-current_check_value;

    assert(abs(K_pressure_difference.(K_names(K_index)))<tolerance,"Modern deep "+K_names(K_index)+" mismatch")
end

%% MyAMI K's

