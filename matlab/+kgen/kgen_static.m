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
            KS = exp(coefficients(1) + coefficients(2)./t + coefficients(3).*log(t) + sqrt(i).*(coefficients(4)./t + coefficients(5) + coefficients(6).*log(t)) + i.*(coefficients(7)./t + coefficients(8) + coefficients(9).*log(t)) + (coefficients(10).*i.^1.5)./t + (coefficients(11).*i.^2)./t + log(1-0.001005*s));
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
        function KSi = calculate_KSi(coefficients,t,s)        
            i = kgen.kgen_static.calculate_ionic_strength(s);
            KSi = exp(coefficients(1)./t + coefficients(2) + coefficients(3)*log(t) + sqrt(i).*(coefficients(4)./t + coefficients(5)) + i.*(coefficients(6)./t + coefficients(7)) + (i.^2).*(coefficients(8)./t + coefficients(9)) + log(1-0.001005*s));
        end

        function K_map = build_K_map()
            K_names = ["K0","K1","K2","KB","KW","KS","KF","KspC","KspA","KP1","KP2","KP3","KSi"];
            K_functions = {@kgen.kgen_static.calculate_K0,@kgen.kgen_static.calculate_K1,@kgen.kgen_static.calculate_K2,@kgen.kgen_static.calculate_KB,@kgen.kgen_static.calculate_KW,@kgen.kgen_static.calculate_KS,@kgen.kgen_static.calculate_KF,@kgen.kgen_static.calculate_KspC,@kgen.kgen_static.calculate_KspA,@kgen.kgen_static.calculate_KP1,@kgen.kgen_static.calculate_KP2,@kgen.kgen_static.calculate_KP3,@kgen.kgen_static.calculate_KSi};
            K_map = containers.Map(K_names,K_functions);
        end

        function pressure_correction = calculate_pressure_correction(name,t,p)
            K_pressure_coefficients = jsondecode(fileread("./../coefficients/K_pressure_correction.json"));
            fundamental_constants = jsondecode(fileread("./../coefficients/fundamental_constants.json"));

            coefficients = K_pressure_coefficients.coefficients.(name);
            rp = fundamental_constants.coefficients.R_P;

            deltaV = coefficients(1) + coefficients(2).*t + coefficients(3).*t.^2;
            deltaK = coefficients(4) + coefficients(5).*t;
            pressure_correction = exp(-(deltaV./(rp*(t+273.15))).*p + (0.5.*deltaK./(rp.*(t+273.15))).*p.^2);
        end
        function seawater_correction = calculate_seawater_correction(names,t,s,mg,ca,method,polynomial_coefficients)
            if nargin<6
                method = "MyAMI";
            end
            if method=="Matlab_Polynomial"
                if nargin<7 || (~isstruct(polynomial_coefficients) && isnan(polynomial_coefficients))
                    polynomial_coefficients = jsondecode(fileread("polynomial_coefficients.json"));
                end
            end

            if method=="Matlab_Polynomial"     
                seawater_correction_names = string(fieldnames(polynomial_coefficients));
                number_of_parameters = 6;
                for name = names
                    if any(seawater_correction_names==name)
                        [x,y,z] = meshgrid(1:number_of_parameters,1:number_of_parameters,1:number_of_parameters);
                        combination_array = unique([x(:),y(:),z(:)],"rows");
                        combination_subset = combination_array(combination_array(:,2)>=combination_array(:,1) & combination_array(:,3)>=combination_array(:,2),:);
                        linear_index = dot(repmat(6.^[2,1,0],size(combination_subset,1),1),combination_subset-1,2)+1;

                        conditions = [ones(numel(t),1),t+273.15,log(t+273.15),s,mg,ca];
                        condition_matrix = reshape(conditions,[numel(t),number_of_parameters,1,1]).*reshape(conditions,[numel(t),1,number_of_parameters,1]).*reshape(conditions,[numel(t),1,1,number_of_parameters]);
                        condition_extracted = condition_matrix(:,linear_index);
        
                        seawater_correction.(name) = dot(condition_extracted,repmat(polynomial_coefficients.(name)',numel(t),1),2);
                    else
                        seawater_correction.(name) = ones(numel(t),1);
                    end
                end
            elseif method=="MyAMI_Polynomial"
                numpy = py.importlib.import_module("numpy");
                pymyami = py.importlib.import_module("pymyami");
                pymyami = py.importlib.reload(pymyami);

                local_t = numpy.array(t);
                local_s = numpy.array(s);
                local_mg = numpy.array(mg);
                local_ca = numpy.array(ca);

                seawater_correction = struct(pymyami.approximate_Fcorr(pyargs("TempC",local_t,"Sal",local_s,"Mg",local_mg,"Ca",local_ca)));
                for name = string(fieldnames(seawater_correction))'
                    seawater_correction.(name) = double(seawater_correction.(name))';
                end
            elseif method=="MyAMI"
                numpy = py.importlib.import_module("numpy");
                pymyami = py.importlib.import_module("pymyami");

                local_t = numpy.array(t);
                local_s = numpy.array(s);
                local_mg = numpy.array(mg);
                local_ca = numpy.array(ca);

                seawater_correction = struct(pymyami.calc_Fcorr(pyargs("TempC",local_t,"Sal",local_s,"Mg",local_mg,"Ca",local_ca)));
                for name = string(fieldnames(seawater_correction))'
                    seawater_correction.(name) = double(seawater_correction.(name))';
                end
            
            else
                error("Unknown method - must be 'MyAMI','MyAMI_Polynomial' or 'Matlab_Polynomial'");
            end
        end

        function pressure = estimate_pressure(pressure)
            pressure(isnan(pressure)) = 0;
        end
        function [calcium,magnesium] = esimate_calcium_magnesium(calcium,magnesium)
            calcium(isnan(calcium)) = 0.0102821;
            magnesium(isnan(magnesium)) = 0.0528171;
        end

        function [K,pressure_correction,seawater_chemistry_correction] = calculate_K(name,temperature,salinity,pressure,calcium,magnesium,seawater_correction_method,polynomial_coefficients)
            if nargin<6
                seawater_correction_method = "MyAMI";
            end
            if nargin<7
                polynomial_coefficients = NaN;
            end
            
            pressure = kgen.kgen_static.estimate_pressure(pressure);
            [calcium,magnesium] = kgen.kgen_static.esimate_calcium_magnesium(calcium,magnesium);
            
            assert(numel(name)==1,"Should have one value for name - did you mean calculate_Ks?")
            assert(all(temperature>=0) && all(temperature<40),"Temperature only valid between 0 and 40C")
            assert(all(salinity>=30) && all(salinity<=40),"Salinity only valid between 30 and 40")
            assert(all(calcium>=0) && all(calcium<=0.06) && all(magnesium>=0) && all(magnesium<=0.06),"Calcium and magnesium concentration only valid between 0 and 0.06 mol/kg")

            K_coefficients = jsondecode(fileread("./../coefficients/K_calculation.json"));

            K_map = kgen.kgen_static.build_K_map();
            assert(isKey(K_map,name),"K not known")
            
            K_function = K_map(name);
            K = K_function(K_coefficients.coefficients.(name),temperature+273.15,salinity);

            pressure_correction = kgen.kgen_static.calculate_pressure_correction(name,temperature,pressure);
            K = K.*pressure_correction;
            
            if seawater_correction_method~="None" && seawater_correction_method~=""
                seawater_chemistry_correction = kgen.kgen_static.calculate_seawater_correction(name,temperature,pressure,calcium,magnesium,seawater_correction_method,polynomial_coefficients);
                K = K.*seawater_chemistry_correction';
            else
                seawater_chemistry_correction = NaN;
            end
        end
        function [Ks,pressure_correction,seawater_correction] = calculate_Ks(names,temperature,salinity,pressure,calcium,magnesium,seawater_correction_method,polynomial_coefficients)
            if nargin<6
                seawater_correction_method = "MyAMI";
            end
            if nargin<7
                polynomial_coefficients = NaN;
            end
            
            pressure = kgen.kgen_static.estimate_pressure(pressure);
            [calcium,magnesium] = kgen.kgen_static.esimate_calcium_magnesium(calcium,magnesium);
            
            if numel(names)==1
                [Ks.(names(1)),pressure_correction.(names(1)),seawater_correction.(names(1))] = kgen.kgen_static.calculate_K(names(1),temperature,salinity,pressure,calcium,magnesium,seawater_correction_method,polynomial_coefficients);
            else
                seawater_correction = kgen.kgen_static.calculate_seawater_correction(names,temperature,salinity,magnesium,calcium,seawater_correction_method,polynomial_coefficients);
                for K_index = 1:numel(names)
                    [Ks.(names(K_index)),pressure_correction.(names(K_index)),~] = kgen.kgen_static.calculate_K(names(K_index),temperature,salinity,pressure,calcium,magnesium,"None",polynomial_coefficients);
                    if any(string(fieldnames(seawater_correction))==names(K_index))
                        seawater_correction.(names(K_index)) = double(seawater_correction.(names(K_index)));
                        Ks.(names(K_index)) = Ks.(names(K_index)).*seawater_correction.(names(K_index));
                    end
                end
            end
        end
        function [Ks,pressure_correction,seawater_correction] = calculate_all_Ks(temperature,salinity,pressure,calcium,magnesium,seawater_correction_method,polynomial_coefficients)
            if nargin<6
                seawater_correction_method = "MyAMI";
            end
            if nargin<7
                polynomial_coefficients = NaN;
            end
            K_map = kgen.kgen_static.build_K_map();
            [Ks,pressure_correction,seawater_correction] = kgen.kgen_static.calculate_Ks(string(keys(K_map)),temperature,salinity,pressure,calcium,magnesium,seawater_correction_method,polynomial_coefficients);
        end
    end
end