classdef kgen_static
    properties
    end
    methods
    end
    methods (Static=true)
        function assumed_temp_c = assume_temp_c()
            assumed_temp_c = 25;
        end
        function assumed_sal = assume_sal()
            assumed_sal = 35;
        end
        function assumed_p_bar = assume_p_bar()
            assumed_p_bar = 0;
        end
        function assumed_magnesium = assume_magnesium()
            assumed_magnesium = 52.8171/1e3;
        end
        function assumed_calcium = assume_calcium()
            assumed_calcium = 10.2821/1e3;
        end

        function ionic_strength = calc_ionic_strength(salinity)
            ionic_strength = (19.924.*salinity)./(1000-1.005.*salinity);
        end
        function K0 = calc_K0(coefficients,temp_c,sal)
            temp_k = temp_c+273.15;
            i = kgen.kgen_static.calc_ionic_strength(sal);
            K0 = exp(coefficients(1) + (100*coefficients(2))./temp_k + coefficients(3).*log(temp_k./100) + sal.*(coefficients(4) + (coefficients(5).*temp_k)./100 + coefficients(6).*(temp_k./100).^2));
        end
        function K1 = calc_K1(coefficients,temp_c,sal)
            temp_k = temp_c+273.15;
            i = kgen.kgen_static.calc_ionic_strength(sal);
            K1 = 10.^(coefficients(1) + coefficients(2)./temp_k + coefficients(3).*log(temp_k) + coefficients(4).*sal + coefficients(5).*sal.^2);
        end
        function K2 = calc_K2(coefficients,temp_c,sal)
            temp_k = temp_c+273.15;
            i = kgen.kgen_static.calc_ionic_strength(sal);
            K2 = 10.^(coefficients(1) + coefficients(2)./temp_k + coefficients(3).*log(temp_k) + coefficients(4).*sal + coefficients(5).*sal.^2);
        end
        function KB = calc_KB(coefficients,temp_c,sal)
            temp_k = temp_c+273.15;
            i = kgen.kgen_static.calc_ionic_strength(sal);
            KB = exp(coefficients(1) + coefficients(2).*sqrt(sal) + coefficients(3).*sal + (1./temp_k).*(coefficients(4) + coefficients(5).*sqrt(sal) + coefficients(6).*sal + coefficients(7).*sal.^1.5 + coefficients(8).*sal.^2) + log(temp_k).*(coefficients(9) + coefficients(10).*sqrt(sal) + coefficients(11).*sal) + coefficients(12).*temp_k.*sqrt(sal));
        end
        function KW = calc_KW(coefficients,temp_c,sal)
            temp_k = temp_c+273.15;
            i = kgen.kgen_static.calc_ionic_strength(sal);
            KW = exp(coefficients(1) + coefficients(2)./temp_k + coefficients(3).*log(temp_k) + sqrt(sal).*(coefficients(4)./temp_k + coefficients(5) + coefficients(6).*log(temp_k)) + coefficients(7).*sal);
        end
        function KS = calc_KS(coefficients,temp_c,sal)
            temp_k = temp_c+273.15;
            i = kgen.kgen_static.calc_ionic_strength(sal);
            KS = exp(coefficients(1) + coefficients(2)./temp_k + coefficients(3).*log(temp_k) + sqrt(i).*(coefficients(4)./temp_k + coefficients(5) + coefficients(6).*log(temp_k)) + i.*(coefficients(7)./temp_k + coefficients(8) + coefficients(9).*log(temp_k)) + (coefficients(10).*i.^1.5)./temp_k + (coefficients(11).*i.^2)./temp_k + log(1-0.001005*sal));
        end
        function KF = calc_KF(coefficients,temp_c,sal)
            temp_k = temp_c+273.15;
            i = kgen.kgen_static.calc_ionic_strength(sal);
            KF = exp(coefficients(1)./temp_k + coefficients(2) + coefficients(3).*sqrt(sal));
        end
        function KspC = calc_KspC(coefficients,temp_c,sal)
            temp_k = temp_c+273.15;
            i = kgen.kgen_static.calc_ionic_strength(sal);
            KspC = 10.^(coefficients(1) + coefficients(2).*temp_k + coefficients(3)./temp_k + coefficients(4).*log10(temp_k) + sqrt(sal).*(coefficients(5) + coefficients(6).*temp_k + coefficients(7)./temp_k) + coefficients(8).*sal + coefficients(9).*sal.^1.5);
        end
        function KspA = calc_KspA(coefficients,temp_c,sal)
            temp_k = temp_c+273.15;
            i = kgen.kgen_static.calc_ionic_strength(sal);
            KspA = 10.^(coefficients(1) + coefficients(2).*temp_k + coefficients(3)./temp_k + coefficients(4).*log10(temp_k) + sqrt(sal).*(coefficients(5) + coefficients(6).*temp_k + coefficients(7)./temp_k) + coefficients(8).*sal + coefficients(9).*sal.^1.5);
        end
        function KP1 = calc_KP1(coefficients,temp_c,sal)
            temp_k = temp_c+273.15;
            i = kgen.kgen_static.calc_ionic_strength(sal);
            KP1 = exp(coefficients(1)./temp_k + coefficients(2) + coefficients(3).*log(temp_k) + sqrt(sal).*(coefficients(4)./temp_k + coefficients(5)) + sal.*(coefficients(6)./temp_k + coefficients(7)));
        end
        function KP2 = calc_KP2(coefficients,temp_c,sal)
            temp_k = temp_c+273.15;
            i = kgen.kgen_static.calc_ionic_strength(sal);
            KP2 = exp(coefficients(1)./temp_k + coefficients(2) + coefficients(3).*log(temp_k) + sqrt(sal).*(coefficients(4)./temp_k + coefficients(5)) + sal.*(coefficients(6)./temp_k + coefficients(7)));
        end
        function KP3 = calc_KP3(coefficients,temp_c,sal)
            temp_k = temp_c+273.15;
            i = kgen.kgen_static.calc_ionic_strength(sal);
            KP3 = exp(coefficients(1)./temp_k + coefficients(2) + sqrt(sal).*(coefficients(3)./temp_k + coefficients(4)) + sal.*(coefficients(5)./temp_k + coefficients(6)));
        end
        function KSi = calc_KSi(coefficients,temp_c,sal)
            temp_k = temp_c+273.15;
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
        function dictionary = python_to_matlab_dictionary(python_dictionary)
            dictionary = containers.Map;
            for key = py.list(keys(python_dictionary))
                value = python_dictionary{key{1}};
                dictionary(string(key)) = value;
            end
        end

        function pressure_correction = calc_pressure_correction(inputs)
            arguments
                inputs.Ks = string(kgen.kgen_static.build_K_map().keys())
                inputs.temp_c double = kgen.kgen_static.assume_temp_c()
                inputs.p_bar double = kgen.kgen_static.assume_p_bar()
            end
            temp_k = inputs.temp_c+273.15;

            K_pressure_coefficients = jsondecode(fileread("./../coefficients/K_pressure_correction.json"));
            fundamental_constants = jsondecode(fileread("./../coefficients/fundamental_constants.json"));
            
            pressure_correction = containers.Map();
            for name = inputs.Ks
                coefficients = K_pressure_coefficients.coefficients.(name);
                rp = fundamental_constants.coefficients.R_P;
    
                deltaV = coefficients(1) + coefficients(2).*inputs.temp_c + coefficients(3).*inputs.temp_c.^2;
                deltaK = coefficients(4) + coefficients(5).*inputs.temp_c;
                pressure_correction(name) = exp(-(deltaV./(rp*(temp_k))).*inputs.p_bar + (0.5.*deltaK./(rp.*(temp_k))).*inputs.p_bar.^2);
            end
            if length(inputs.Ks)==1
                pressure_correction = pressure_correction(inputs.Ks);
            end
        end
        function seawater_correction_output = calc_seawater_correction(inputs)
            arguments
                inputs.names = kgen.kgen_static.build_K_map()
                inputs.temp_c double = kgen.kgen_static.assume_temp_c()
                inputs.sal double = kgen.kgen_static.assume_sal()
                inputs.magnesium double = kgen.kgen_static.assume_magnesium()
                inputs.calcium double = kgen.kgen_static.assume_calcium()
                inputs.seawater_correction_method = "MyAMI"
                inputs.polynomial_coefficients = jsondecode(fileread("polynomial_coefficients.json"));
            end

            temp_k = inputs.temp_c+273.15;

            if inputs.seawater_correction_method=="Matlab_Polynomial"     
                seawater_correction_names = string(fieldnames(inputs.polynomial_coefficients));
                number_of_parameters = 6;
                seawater_correction_output = containers.Map();
                for name = inputs.names
                    if any(seawater_correction_names==name)
                        [x,y,z] = meshgrid(1:number_of_parameters,1:number_of_parameters,1:number_of_parameters);
                        combination_array = unique([x(:),y(:),z(:)],"rows");
                        combination_subset = combination_array(combination_array(:,2)>=combination_array(:,1) & combination_array(:,3)>=combination_array(:,2),:);
                        linear_index = dot(repmat(6.^[2,1,0],size(combination_subset,1),1),combination_subset-1,2)+1;

                        conditions = [ones(numel(temp_k),1),temp_k,log(temp_k),inputs.sal,inputs.magnesium,inputs.calcium];
                        condition_matrix = reshape(conditions,[numel(temp_k),number_of_parameters,1,1]).*reshape(conditions,[numel(temp_k),1,number_of_parameters,1]).*reshape(conditions,[numel(temp_k),1,1,number_of_parameters]);
                        condition_extracted = condition_matrix(:,linear_index);
        
                        seawater_correction_output(name) = dot(condition_extracted,repmat(inputs.polynomial_coefficients.(name)',numel(temp_k),1),2);
                    else
                        seawater_correction_output(name) = 1;
                    end
                end
            elseif inputs.seawater_correction_method=="MyAMI_Polynomial"
                numpy = py.importlib.import_module("numpy");
                pymyami = py.importlib.import_module("pymyami");
                pymyami = py.importlib.reload(pymyami);

                local_t = numpy.array(inputs.temp_c);
                local_s = numpy.array(inputs.sal);
                local_mg = numpy.array(inputs.magnesium);
                local_ca = numpy.array(inputs.calcium);

                seawater_correction = kgen.kgen_static.python_to_matlab_dictionary(pymyami.approximate_seawater_correction(pyargs("TempC",local_t,"Sal",local_s,"Mg",local_mg,"Ca",local_ca)));
                seawater_correction_output = containers.Map();
                for name = inputs.names
                    if seawater_correction.isKey(name)
                        seawater_correction_output(name) = double(seawater_correction(name))';
                    else
                        seawater_correction_output(name) = 1;
                    end
                end
            elseif inputs.seawater_correction_method=="MyAMI"
                numpy = py.importlib.import_module("numpy");
                pymyami = py.importlib.import_module("pymyami");

                local_t = numpy.array(inputs.temp_c);
                local_s = numpy.array(inputs.sal);
                local_mg = numpy.array(inputs.magnesium);
                local_ca = numpy.array(inputs.calcium);

                seawater_correction = kgen.kgen_static.python_to_matlab_dictionary(pymyami.calculate_seawater_correction(pyargs("TempC",local_t,"Sal",local_s,"Mg",local_mg,"Ca",local_ca)));
                seawater_correction_output = containers.Map();
                for name = inputs.names
                    if seawater_correction.isKey(name)
                        seawater_correction_output(name) = double(seawater_correction(name))';
                    else
                        seawater_correction_output(name) = 1.0;
                    end
                end
            
            else
                error("Unknown method - must be 'MyAMI','MyAMI_Polynomial' or 'Matlab_Polynomial'");
            end
        end

        function K = calc_K(name,inputs)
            arguments
                name
                inputs.temp_c double = kgen.kgen_static.assume_temp_c()
                inputs.sal double = kgen.kgen_static.assume_sal()
                inputs.p_bar double = kgen.kgen_static.assume_p_bar()
                inputs.magnesium double = kgen.kgen_static.assume_magnesium()
                inputs.calcium double = kgen.kgen_static.assume_calcium()
                inputs.seawater_correction_method string = "MyAMI"
                inputs.polynomial_coefficients
            end
            % 
            % assert(numel(name)==1,"Should have one value for name - did you mean calc_Ks?")
            % assert(all(temp_c>=0) && all(temp_c<40),"Temperature only valid between 0 and 40C")
            % assert(all(p_bar>=0),"Pressure must be greater than 0bar")
            % assert(all(sal>=30) && all(sal<=40),"Salinity only valid between 30 and 40")
            % assert(all(calcium>=0) && all(calcium<=0.06) && all(magnesium>=0) && all(magnesium<=0.06),"Calcium and magnesium concentration only valid between 0 and 0.06 mol/kg")

            K_coefficients = jsondecode(fileread("./../coefficients/K_calculation.json"));

            K_map = kgen.kgen_static.build_K_map();
            assert(isKey(K_map,name),"K not known")
            
            K_function = K_map(name);
            K = K_function(K_coefficients.coefficients.(name),inputs.temp_c,inputs.sal);

            sulphate = kgen.kgen_static.calc_sulphate(inputs.sal);
            fluorine = kgen.kgen_static.calc_fluorine(inputs.sal);
            KS_surf = kgen.kgen_static.calc_KS(K_coefficients.coefficients.("KS"),inputs.temp_c,inputs.sal);
            KS_deep = KS_surf .* kgen.kgen_static.calc_pressure_correction(Ks="KS",temp_c=inputs.temp_c,p_bar=inputs.p_bar);
            KF_surf = kgen.kgen_static.calc_KF(K_coefficients.coefficients.("KF"),inputs.temp_c,inputs.sal);
            KF_deep = KF_surf .* kgen.kgen_static.calc_pressure_correction(Ks="KF",temp_c=inputs.temp_c,p_bar=inputs.p_bar);
            
            tot_to_sws_surface = (1+sulphate./KS_surf+fluorine./KF_surf)./(1+sulphate./KS_surf);
            sws_to_tot_deep = (1+sulphate./KS_deep)./(1+sulphate./KS_deep+fluorine./KF_deep);

            pressure_correction = kgen.kgen_static.calc_pressure_correction(Ks=name,temp_c=inputs.temp_c,p_bar=inputs.p_bar);

            K = K.*tot_to_sws_surface.*pressure_correction.*sws_to_tot_deep;
            
            if inputs.seawater_correction_method~="None" && inputs.seawater_correction_method~=""
                seawater_chemistry_correction = kgen.kgen_static.calc_seawater_correction(names=[name],temp_c=inputs.temp_c,sal=inputs.sal,magnesium=inputs.magnesium,calcium=inputs.calcium,seawater_correction_method=inputs.seawater_correction_method);
                K = K.*seawater_chemistry_correction(name);
            else
                seawater_chemistry_correction = NaN;
            end
        end
        function Ks = calc_Ks(inputs)
            arguments
                inputs.names = kgen.kgen_static.build_K_map();
                inputs.temp_c double = kgen.kgen_static.assume_temp_c()
                inputs.sal double = kgen.kgen_static.assume_sal()
                inputs.p_bar double = kgen.kgen_static.assume_p_bar()
                inputs.magnesium double = kgen.kgen_static.assume_magnesium()
                inputs.calcium double = kgen.kgen_static.assume_calcium()
                inputs.seawater_correction_method = "MyAMI"
            end

            names = string(inputs.names.keys());

            for K_index = 1:numel(names)
                Ks.(names(K_index)) = kgen.kgen_static.calc_K(names(K_index),temp_c=inputs.temp_c,sal=inputs.sal,p_bar=inputs.p_bar,magnesium=inputs.magnesium,calcium=inputs.calcium,seawater_correction_method=inputs.seawater_correction_method);
                % if any(string(fieldnames(seawater_correction))==names(K_index))
                %     seawater_correction.(names(K_index)) = double(seawater_correction.(names(K_index)));
                %     Ks.(names(K_index)) = Ks.(names(K_index)).*seawater_correction.(names(K_index));
                % end
            end
        end

    end
end 