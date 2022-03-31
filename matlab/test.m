run("./kgen/K_functions.m");
K_names = string(K_dictionary.keys());

pressure_functions = jsondecode(fileread("./kgen/Pressure_functions.json"));
fundamental_constants = jsondecode(fileread("./../coefficients/fundamental_constants.json"));

K_coefficients = jsondecode(fileread("./../coefficients/K_calculation.json"));
K_pressure_coefficients = jsondecode(fileread("./../coefficients/K_pressure_correction.json"));

check_values = jsondecode(fileread("./../check_values/check_Ks.json"));
pressure_check_values = jsondecode(fileread("./../check_values/check_presscorr.json"));

deltaV_function = str2func(pressure_functions.deltaV);
deltaK_function = str2func(pressure_functions.deltaK);
correction_function = str2func(pressure_functions.correction);
% correction_function = str2func("@(rp,t,p,deltaV,deltaK) -(deltaV./(rp*(t+273.15)))*p");

temperature = check_values.input_conditions.TC;
salinity = check_values.input_conditions.S;
ionic_strength = (19.924.*salinity)./(1000-1.005.*salinity); % see Dickson 2007

pressure = pressure_check_values.input_conditions.P;
R_P = fundamental_constants.coefficients.R_P;

for K_index = 1:numel(K_names)
    K_output.(K_names(K_index)) = NaN;
end

tolerance = 1;

%% Modern surface K's
tolerance = 1e-2;

% Iterate over K's to calculate value + difference from check value
for K_index = 1:numel(K_names)
    current_function = K_dictionary(K_names(K_index));
    current_coefficients = K_coefficients.coefficients.(K_names(K_index));
    current_check_value = check_values.check_values.(K_names(K_index));

    K_output.(K_names(K_index)) = log(current_function(current_coefficients,temperature+273.15,salinity,ionic_strength));
    K_difference.(K_names(K_index)) = K_output.(K_names(K_index))-current_check_value;

    assert(abs(K_difference.(K_names(K_index)))<tolerance,"Modern surface "+K_names(K_index)+" mismatch")
end


%% Modern deep K's
tolerance = 1e-3;

% Iterate over K's to calculate value at depth + difference from check value
for K_index = 1:numel(K_names)
    current_coefficients = K_pressure_coefficients.coefficients.(K_names(K_index));
    current_check_value = pressure_check_values.check_values.(K_names(K_index));

    deltaV = deltaV_function(current_coefficients(1:3),temperature);
    deltaK = deltaK_function(current_coefficients(4:5),temperature);

    K_pressure_correction.(K_names(K_index)) = correction_function(R_P,temperature,pressure,deltaV,deltaK);
    K_pressure_output.(K_names(K_index)) = log(exp(K_output.(K_names(K_index))).*K_pressure_correction.(K_names(K_index)));
    K_pressure_difference.(K_names(K_index)) = K_pressure_correction.(K_names(K_index))-current_check_value;

    assert(abs(K_pressure_difference.(K_names(K_index)))<tolerance,"Modern deep "+K_names(K_index)+" mismatch")
end

%% MyAMI K's

