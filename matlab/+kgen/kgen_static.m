classdef kgen_static
    properties
    end
    methods
    end
    methods (Static=true)
        function ionic_strength = calculate_ionic_strength(salinity)
            ionic_strength = (19.924.*salinity)./(1000-1.005.*salinity);
        end
        function K0 = calculate_K0(coefficients,t,s)
            i = kgen.kgen_static.calculate_ionic_strength(s);
            K0 = exp(coefficients(1) + (100*coefficients(2))./t + coefficients(3).*log(t./100) + s.*(coefficients(4) + (coefficients(5).*t)./100 + coefficients(6).*(t./100).^2));
        end
        function K1 = calculate_K1(coefficients,t,s)
            i = kgen.kgen_static.calculate_ionic_strength(s);
            K1 = 10.^(coefficients(1) + coefficients(2)./t + coefficients(3).*log(t) + coefficients(4).*s + coefficients(5).*s.^2);
        end
        function K2 = calculate_K2(coefficients,t,s)
            i = kgen.kgen_static.calculate_ionic_strength(s);
            K2 = 10.^(coefficients(1) + coefficients(2)./t + coefficients(3).*log(t) + coefficients(4).*s + coefficients(5).*s.^2);
        end
        function KB = calculate_KB(coefficients,t,s)
            i = kgen.kgen_static.calculate_ionic_strength(s);
            KB = exp(coefficients(1) + coefficients(2).*sqrt(s) + coefficients(3).*s + (1./t).*(coefficients(4) + coefficients(5).*sqrt(s) + coefficients(6).*s + coefficients(7).*s.^1.5 + coefficients(8).*s.^2) + log(t).*(coefficients(9) + coefficients(10).*sqrt(s) + coefficients(11).*s) + coefficients(12).*t.*sqrt(s));
        end
        function KW = calculate_KW(coefficients,t,s)
            i = kgen.kgen_static.calculate_ionic_strength(s);
            KW = exp(coefficients(1) + coefficients(2)./t + coefficients(3).*log(t) + sqrt(s).*(coefficients(4)./t + coefficients(5) + coefficients(6).*log(t)) + coefficients(7).*s);
        end
        function KS = calculate_KS(coefficients,t,s)
            i = kgen.kgen_static.calculate_ionic_strength(s);
            KS = exp(coefficients(1) + coefficients(2)./t + coefficients(3).*log(t) + sqrt(i).*(coefficients(4)./t + coefficients(5) + coefficients(6).*log(t)) + i.*(coefficients(7)./t + coefficients(8) + coefficients(9).*log(t)) + (coefficients(10).*i.^1.5)/t + (coefficients(11).*i.^2)/t + log(1-0.001005*s));
        end
        function KF = calculate_KF(coefficients,t,s)
            i = kgen.kgen_static.calculate_ionic_strength(s);
            KF = exp(coefficients(1)./t + coefficients(2) + coefficients(3).*sqrt(s));
        end
        function KspC = calculate_KspC(coefficients,t,s)
            i = kgen.kgen_static.calculate_ionic_strength(s);
            KspC = 10.^(coefficients(1) + coefficients(2).*t + coefficients(3)./t + coefficients(4).*log10(t) + sqrt(s).*(coefficients(5) + coefficients(6).*t + coefficients(7)./t) + coefficients(8).*s + coefficients(9).*s.^1.5);
        end
        function KspA = calculate_KspA(coefficients,t,s)
            i = kgen.kgen_static.calculate_ionic_strength(s);
            KspA = 10.^(coefficients(1) + coefficients(2).*t + coefficients(3)./t + coefficients(4).*log10(t) + sqrt(s).*(coefficients(5) + coefficients(6).*t + coefficients(7)./t) + coefficients(8).*s + coefficients(9).*s.^1.5);
        end
        function KP1 = calculate_KP1(coefficients,t,s)
            i = kgen.kgen_static.calculate_ionic_strength(s);
            KP1 = exp(coefficients(1)./t + coefficients(2) + coefficients(3).*log(t) + sqrt(s).*(coefficients(4)./t + coefficients(5)) + s.*(coefficients(6)./t + coefficients(7)));
        end
        function KP2 = calculate_KP2(coefficients,t,s)
            i = kgen.kgen_static.calculate_ionic_strength(s);
            KP2 = exp(coefficients(1)./t + coefficients(2) + coefficients(3).*log(t) + sqrt(s).*(coefficients(4)./t + coefficients(5)) + s.*(coefficients(6)./t + coefficients(7)));
        end
        function KP3 = calculate_KP3(coefficients,t,s)
            i = kgen.kgen_static.calculate_ionic_strength(s);
            KP3 = exp(coefficients(1)./t + coefficients(2) + sqrt(s).*(coefficients(3)./t + coefficients(4)) + s.*(coefficients(5)./t + coefficients(6)));
        end

        function K_map = build_K_map()
            K_names = ["K0","K1","K2","KB","KW","KS","KF","KspC","KspA","KP1","KP2","KP3"];
            K_functions = {@kgen.kgen_static.calculate_K0,@kgen.kgen_static.calculate_K1,@kgen.kgen_static.calculate_K2,@kgen.kgen_static.calculate_KB,@kgen.kgen_static.calculate_KW,@kgen.kgen_static.calculate_KS,@kgen.kgen_static.calculate_KF,@kgen.kgen_static.calculate_KspC,@kgen.kgen_static.calculate_KspA,@kgen.kgen_static.calculate_KP1,@kgen.kgen_static.calculate_KP2,@kgen.kgen_static.calculate_KP3};
            K_map = containers.Map(K_names,K_functions);
        end

        function pressure_correction = calculate_pressure_correction(name,t,p)
            K_pressure_coefficients = jsondecode(fileread("./../coefficients/K_pressure_correction.json"));
            fundamental_constants = jsondecode(fileread("./../coefficients/fundamental_constants.json"));

            coefficients = K_pressure_coefficients.coefficients.(name);
            rp = fundamental_constants.coefficients.R_P;

            deltaV = coefficients(1) + coefficients(2).*t + coefficients(3).*t.^2;
            deltaK = coefficients(4) + coefficients(5).*t;
            pressure_correction = exp(-(deltaV./(rp*(t+273.15))).*p + (0.5.*deltaK/(rp.*(t+273.15))).*p.^2);
        end
        function seawater_correction = calculate_seawater_correction(name,t,s,mg,ca)
            polynomial_coefficients = jsondecode(fileread("./polynomial_coefficients.json"));
            seawater_correction_names = string(fieldnames(polynomial_coefficients));
            if ~any(name==seawater_correction_names)
                seawater_correction = 1;
                return
            end
            polynomial_values = NaN(1,56);
            seawater_correction = NaN(numel(t),1);

            for condition_index = 1:numel(t)
                conditions = [1,t(condition_index)+273.15,log(t(condition_index)+273.15),s(condition_index),mg(condition_index),ca(condition_index)];
    
                condition_matrix = conditions.*conditions'.*reshape(conditions,[1,1,6]);
                polynomial_values = NaN(56,1);
    
                count = 1;
                for order_1 = 1:size(condition_matrix,1)
                    for order_2 = 1:size(condition_matrix,2)
                        for order_3 = 1:size(condition_matrix,2)
                            if ((order_1<=order_2) && (order_2<=order_3))
                                polynomial_values(count) = condition_matrix(order_1,order_2,order_3);
                                count = count+1;
                            end
                        end
                    end
                end
    
                seawater_correction(condition_index) = dot(polynomial_coefficients.(name),polynomial_values);
            end
        end

        function pressure = estimate_pressure(pressure)
            pressure(isnan(pressure)) = 0;
        end
        function [calcium,magnesium] = esimate_calcium_magnesium(calcium,magnesium)
            calcium(isnan(calcium)) = 0.0102821;
            magnesium(isnan(magnesium)) = 0.0528171;
        end

        function [K,pressure_correction,seawater_chemistry_correction] = calculate_K(name,temperature,salinity,pressure,calcium,magnesium)
            pressure = kgen.kgen_static.estimate_pressure(pressure);
            [calcium,magnesium] = kgen.kgen_static.esimate_calcium_magnesium(calcium,magnesium);
            
            assert(numel(name)==1,"Should have one value for name - did you mean calculate_Ks?")
            assert(all(temperature>0) && all(temperature<40),"Temperature only valid between 0 and 40C")
            assert(all(salinity>30) && all(salinity<40),"Salinity only valid between 30 and 40")
            assert(all(calcium>0) && all(calcium<0.06) && all(magnesium>0) && all(magnesium<0.06),"Calcium and magnesium concentration only valid between 0 and 0.06 mol/kg")

            K_coefficients = jsondecode(fileread("./../coefficients/K_calculation.json"));

            K_map = kgen.kgen_static.build_K_map();
            assert(isKey(K_map,name),"K not known")
            
            K_function = K_map(name);
            K = K_function(K_coefficients.coefficients.(name),temperature+273.15,salinity);

            pressure_correction = kgen.kgen_static.calculate_pressure_correction(name,temperature,pressure);
            K = K.*pressure_correction;
            
            seawater_chemistry_correction = kgen.kgen_static.calculate_seawater_correction(name,temperature,pressure,calcium,magnesium);
            K = K.*seawater_chemistry_correction';
        end
        function [Ks,pressure_correction,seawater_correction] = calculate_Ks(names,temperature,salinity,pressure,calcium,magnesium)
            for K_index = 1:numel(names)
                [Ks.(names(K_index)),pressure_correction.(names(K_index)),seawater_correction.(names(K_index))] = kgen.kgen_static.calculate_K(names(K_index),temperature,salinity,pressure,calcium,magnesium);
            end
        end
        function [Ks,pressure_correction,seawater_correction] = calculate_all_Ks(temperature,salinity,pressure,calcium,magnesium)
            K_map = kgen.kgen_static.build_K_map();
            [Ks,pressure_correction,seawater_correction] = kgen.kgen_static.calculate_Ks(string(keys(K_map)),temperature,salinity,pressure,calcium,magnesium);
        end
    end
end