classdef kgen_static
    properties
    end
    methods
    end
    methods (Static=true)
        function ionic_strength = calc_ionic_strength(salinity)
            ionic_strength = (19.924.*salinity)./(1000-1.005.*salinity);
        end
        function K0 = calc_K0(coefficients,temp_k,sal)
            i = kgen.kgen_static.calc_ionic_strength(sal);
            K0 = exp(coefficients(1) + (100*coefficients(2))./temp_k + coefficients(3).*log(temp_k./100) + sal.*(coefficients(4) + (coefficients(5).*temp_k)./100 + coefficients(6).*(temp_k./100).^2));
        end
        function K1 = calc_K1(coefficients,temp_k,sal)
            i = kgen.kgen_static.calc_ionic_strength(sal);
            K1 = 10.^(coefficients(1) + coefficients(2)./temp_k + coefficients(3).*log(temp_k) + coefficients(4).*sal + coefficients(5).*sal.^2);
        end
        function K2 = calc_K2(coefficients,temp_k,sal)
            i = kgen.kgen_static.calc_ionic_strength(sal);
            K2 = 10.^(coefficients(1) + coefficients(2)./temp_k + coefficients(3).*log(temp_k) + coefficients(4).*sal + coefficients(5).*sal.^2);
        end
        function KB = calc_KB(coefficients,temp_k,sal)
            i = kgen.kgen_static.calc_ionic_strength(sal);
            KB = exp(coefficients(1) + coefficients(2).*sqrt(sal) + coefficients(3).*sal + (1./temp_k).*(coefficients(4) + coefficients(5).*sqrt(sal) + coefficients(6).*sal + coefficients(7).*sal.^1.5 + coefficients(8).*sal.^2) + log(temp_k).*(coefficients(9) + coefficients(10).*sqrt(sal) + coefficients(11).*sal) + coefficients(12).*temp_k.*sqrt(sal));
        end
        function KW = calc_KW(coefficients,temp_k,sal)
            i = kgen.kgen_static.calc_ionic_strength(sal);
            KW = exp(coefficients(1) + coefficients(2)./temp_k + coefficients(3).*log(temp_k) + sqrt(sal).*(coefficients(4)./temp_k + coefficients(5) + coefficients(6).*log(temp_k)) + coefficients(7).*sal);
        end
        function KS = calc_KS(coefficients,temp_k,sal)
            i = kgen.kgen_static.calc_ionic_strength(sal);
            KS = exp(coefficients(1) + coefficients(2)./temp_k + coefficients(3).*log(temp_k) + sqrt(i).*(coefficients(4)./temp_k + coefficients(5) + coefficients(6).*log(temp_k)) + i.*(coefficients(7)./temp_k + coefficients(8) + coefficients(9).*log(temp_k)) + (coefficients(10).*i.^1.5)./temp_k + (coefficients(11).*i.^2)./temp_k + log(1-0.001005*sal));
        end
        function KF = calc_KF(coefficients,temp_k,sal)
            i = kgen.kgen_static.calc_ionic_strength(sal);
            KF = exp(coefficients(1)./temp_k + coefficients(2) + coefficients(3).*sqrt(sal));
        end
        function KspC = calc_KspC(coefficients,temp_k,sal)
            i = kgen.kgen_static.calc_ionic_strength(sal);
            KspC = 10.^(coefficients(1) + coefficients(2).*temp_k + coefficients(3)./temp_k + coefficients(4).*log10(temp_k) + sqrt(sal).*(coefficients(5) + coefficients(6).*temp_k + coefficients(7)./temp_k) + coefficients(8).*sal + coefficients(9).*sal.^1.5);
        end
        function KspA = calc_KspA(coefficients,temp_k,sal)
            i = kgen.kgen_static.calc_ionic_strength(sal);
            KspA = 10.^(coefficients(1) + coefficients(2).*temp_k + coefficients(3)./temp_k + coefficients(4).*log10(temp_k) + sqrt(sal).*(coefficients(5) + coefficients(6).*temp_k + coefficients(7)./temp_k) + coefficients(8).*sal + coefficients(9).*sal.^1.5);
        end
        function KP1 = calc_KP1(coefficients,temp_k,sal)
            i = kgen.kgen_static.calc_ionic_strength(sal);
            KP1 = exp(coefficients(1)./temp_k + coefficients(2) + coefficients(3).*log(temp_k) + sqrt(sal).*(coefficients(4)./temp_k + coefficients(5)) + sal.*(coefficients(6)./temp_k + coefficients(7)));
        end
        function KP2 = calc_KP2(coefficients,temp_k,sal)
            i = kgen.kgen_static.calc_ionic_strength(sal);
            KP2 = exp(coefficients(1)./temp_k + coefficients(2) + coefficients(3).*log(temp_k) + sqrt(sal).*(coefficients(4)./temp_k + coefficients(5)) + sal.*(coefficients(6)./temp_k + coefficients(7)));
        end
        function KP3 = calc_KP3(coefficients,temp_k,sal)
            i = kgen.kgen_static.calc_ionic_strength(sal);
            KP3 = exp(coefficients(1)./temp_k + coefficients(2) + sqrt(sal).*(coefficients(3)./temp_k + coefficients(4)) + sal.*(coefficients(5)./temp_k + coefficients(6)));
        end
        function KSi = calc_KSi(coefficients,temp_k,sal)
            i = kgen.kgen_static.calc_ionic_strength(sal);
            KSi = exp(coefficients(1)./temp_k + coefficients(2) + coefficients(3)*log(temp_k) + sqrt(i).*(coefficients(4)./temp_k + coefficients(5)) + i.*(coefficients(6)./temp_k + coefficients(7)) + (i.^2).*(coefficients(8)./temp_k + coefficients(9)) + log(1-0.001005*sal));
        end
        function fluorine = calc_fluorine(sal)
            fluorine = sal*(1.952125747e-6);  % mol/kg-SW
        end
        function sulphate = calc_sulphate(sal)
            sulphate = sal*(8.067266895e-4);  % mol/kg-SW
        end

        function K_map = build_K_map()
            K_names = ["K0","K1","K2","KB","KW","KS","KF","KspC","KspA","KP1","KP2","KP3","KSi"];
            K_functions = {@kgen.kgen_static.calc_K0,@kgen.kgen_static.calc_K1,@kgen.kgen_static.calc_K2,@kgen.kgen_static.calc_KB,@kgen.kgen_static.calc_KW,@kgen.kgen_static.calc_KS,@kgen.kgen_static.calc_KF,@kgen.kgen_static.calc_KspC,@kgen.kgen_static.calc_KspA,@kgen.kgen_static.calc_KP1,@kgen.kgen_static.calc_KP2,@kgen.kgen_static.calc_KP3,@kgen.kgen_static.calc_KSi};
            K_map = containers.Map(K_names,K_functions);
        end

        function pressure_correction = calc_pressure_correction(name,temp_k,p)
            K_pressure_coefficients = jsondecode(fileread("./../coefficients/K_pressure_correction.json"));
            fundamental_constants = jsondecode(fileread("./../coefficients/fundamental_constants.json"));

            coefficients = K_pressure_coefficients.coefficients.(name);
            rp = fundamental_constants.coefficients.R_P;

            deltaV = coefficients(1) + coefficients(2).*temp_k + coefficients(3).*temp_k.^2;
            deltaK = coefficients(4) + coefficients(5).*temp_k;
            pressure_correction = exp(-(deltaV./(rp*(temp_k+273.15))).*p + (0.5.*deltaK./(rp.*(temp_k+273.15))).*p.^2);
        end
        function seawater_correction = calc_seawater_correction(names,temp_k,sal,magnesium,calcium,method,polynomial_coefficients)
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

                        conditions = [ones(numel(temp_k),1),temp_k+273.15,log(temp_k+273.15),sal,mg,ca];
                        condition_matrix = reshape(conditions,[numel(temp_k),number_of_parameters,1,1]).*reshape(conditions,[numel(temp_k),1,number_of_parameters,1]).*reshape(conditions,[numel(temp_k),1,1,number_of_parameters]);
                        condition_extracted = condition_matrix(:,linear_index);
        
                        seawater_correction.(name) = dot(condition_extracted,repmat(polynomial_coefficients.(name)',numel(temp_k),1),2);
                    else
                        seawater_correction.(name) = ones(numel(temp_k),1);
                    end
                end
            elseif method=="MyAMI_Polynomial"
                numpy = py.importlib.import_module("numpy");
                pymyami = py.importlib.import_module("pymyami");
                pymyami = py.importlib.reload(pymyami);

                local_t = numpy.array(temp_k);
                local_s = numpy.array(sal);
                local_mg = numpy.array(magnesium);
                local_ca = numpy.array(calcium);

                seawater_correction = struct(pymyami.approximate_seawater_correction(pyargs("TempC",local_t,"Sal",local_s,"Mg",local_mg,"Ca",local_ca)));
                for name = string(fieldnames(seawater_correction))'
                    seawater_correction.(name) = double(seawater_correction.(name))';
                end
            elseif method=="MyAMI"
                numpy = py.importlib.import_module("numpy");
                pymyami = py.importlib.import_module("pymyami");

                local_t = numpy.array(temp_k);
                local_s = numpy.array(sal);
                local_mg = numpy.array(magnesium);
                local_ca = numpy.array(calcium);

                seawater_correction = struct(pymyami.calculate_seawater_correction(pyargs("TempC",local_t,"Sal",local_s,"Mg",local_mg,"Ca",local_ca)));
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

        function [K,pressure_correction,seawater_chemistry_correction] = calc_K(name,temp_c,sal,p_bar,magnesium,calcium,seawater_correction_method,polynomial_coefficients)
            if nargin<6
                seawater_correction_method = "MyAMI";
            end
            if nargin<7
                polynomial_coefficients = NaN;
            end
            
            p_bar = kgen.kgen_static.estimate_pressure(p_bar);
            [calcium,magnesium] = kgen.kgen_static.esimate_calcium_magnesium(calcium,magnesium);
            
            assert(numel(name)==1,"Should have one value for name - did you mean calc_Ks?")
            assert(all(temp_c>=0) && all(temp_c<40),"Temperature only valid between 0 and 40C")
            assert(all(sal>=30) && all(sal<=40),"Salinity only valid between 30 and 40")
            assert(all(calcium>=0) && all(calcium<=0.06) && all(magnesium>=0) && all(magnesium<=0.06),"Calcium and magnesium concentration only valid between 0 and 0.06 mol/kg")

            K_coefficients = jsondecode(fileread("./../coefficients/K_calculation.json"));

            K_map = kgen.kgen_static.build_K_map();
            assert(isKey(K_map,name),"K not known")
            
            K_function = K_map(name);
            K = K_function(K_coefficients.coefficients.(name),temp_c+273.15,sal);

            sulphate = kgen.kgen_static.calc_sulphate(sal);
            fluorine = kgen.kgen_static.calc_fluorine(sal);
            KS_surf = kgen.kgen_static.calc_KS(K_coefficients.coefficients.("KS"),temp_c+273.15,sal);
            KS_deep = KS_surf .* kgen.kgen_static.calc_pressure_correction("KS",temp_c,p_bar);
            KF_surf = kgen.kgen_static.calc_KF(K_coefficients.coefficients.("KF"),temp_c+273.15,sal);
            KF_deep = KF_surf .* kgen.kgen_static.calc_pressure_correction("KF",temp_c,p_bar);
            
            tot_to_sws_surface = (1+sulphate./KS_surf)./(1+sulphate./KS_surf+fluorine./KF_surf);
            sws_to_tot_deep = (1+sulphate./KS_deep+fluorine./KF_deep)./(1+sulphate./KS_deep);

            pressure_correction = kgen.kgen_static.calc_pressure_correction(name,temp_c,p_bar);

            K = K.*tot_to_sws_surface.*pressure_correction.*sws_to_tot_deep;
            
            if seawater_correction_method~="None" && seawater_correction_method~=""
                seawater_chemistry_correction = kgen.kgen_static.calc_seawater_correction(name,temp_c,p_bar,magnesium,calcium,seawater_correction_method,polynomial_coefficients);
                K = K.*seawater_chemistry_correction';
            else
                seawater_chemistry_correction = NaN;
            end
        end
        function [Ks,pressure_correction,seawater_correction] = calc_Ks(names,temp_c,sal,p_bar,magnesium,calcium,seawater_correction_method,polynomial_coefficients)
            if nargin<6
                seawater_correction_method = "MyAMI";
            end
            if nargin<7
                polynomial_coefficients = NaN;
            end
            
            p_bar = kgen.kgen_static.estimate_pressure(p_bar);
            [calcium,magnesium] = kgen.kgen_static.esimate_calcium_magnesium(calcium,magnesium);
            
            if numel(names)==1
                [Ks.(names(1)),pressure_correction.(names(1)),seawater_correction.(names(1))] = kgen.kgen_static.calc_K(names(1),temp_c,sal,p_bar,magnesium,calcium,seawater_correction_method,polynomial_coefficients);
            else
                seawater_correction = struct();
                if seawater_correction_method~="None" && seawater_correction_method~=""
                    seawater_correction = kgen.kgen_static.calc_seawater_correction(names,temp_c,sal,magnesium,calcium,seawater_correction_method,polynomial_coefficients);
                end
                for K_index = 1:numel(names)
                    [Ks.(names(K_index)),pressure_correction.(names(K_index)),~] = kgen.kgen_static.calc_K(names(K_index),temp_c,sal,p_bar,magnesium,calcium,"None",polynomial_coefficients);
                    if any(string(fieldnames(seawater_correction))==names(K_index))
                        seawater_correction.(names(K_index)) = double(seawater_correction.(names(K_index)));
                        Ks.(names(K_index)) = Ks.(names(K_index)).*seawater_correction.(names(K_index));
                    end
                end
            end
        end
        function [Ks,pressure_correction,seawater_correction] = calc_all_Ks(temp_c,sal,pres,magnesium,calcium,seawater_correction_method,polynomial_coefficients)
            if nargin<6
                seawater_correction_method = "MyAMI";
            end
            if nargin<7
                polynomial_coefficients = NaN;
            end
            K_map = kgen.kgen_static.build_K_map();
            [Ks,pressure_correction,seawater_correction] = kgen.kgen_static.calc_Ks(string(keys(K_map)),temp_c,sal,pres,magnesium,calcium,seawater_correction_method,polynomial_coefficients);
        end
    end
end 