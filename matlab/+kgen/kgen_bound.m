classdef kgen_bound < kgen.kgen_static
    properties
        temperature = NaN
        salinity = NaN
        pressure = NaN
        calcium = NaN
        magnesium = NaN

        K_coefficients
    end
    methods
        function self = kgen_bound()
            self.K_coefficients = jsondecode(fileread("./../coefficients/K_calculation.json")).coefficients;
        end
        function K0 = self_calculate_K0(self)
            K0 = self.calculate_K0(self.K_coefficients.K0,self.temperature+273.15,self.salinity);
        end
        function K1 = self_calculate_K1(self)
            K1 = self.calculate_K0(self.K_coefficients.K0,self.temperature+273.15,self.salinity);
        end
        function K2 = self_calculate_K2(self)
            K2 = self.calculate_K0(self.K_coefficients.K0,self.temperature+273.15,self.salinity);
        end
        function KB = self_calculate_KB(self)
            KB = self.calculate_K0(self.K_coefficients.K0,self.temperature+273.15,self.salinity);
        end
        function KW = self_calculate_KW(self)
            KW = self.calculate_K0(self.K_coefficients.K0,self.temperature+273.15,self.salinity);
        end
        function KS = self_calculate_KS(self)
            KS = self.calculate_K0(self.K_coefficients.K0,self.temperature+273.15,self.salinity);
        end
        function KF = self_calculate_KF(self)
            KF = self.calculate_K0(self.K_coefficients.K0,self.temperature+273.15,self.salinity);
        end
        function KspC = self_calculate_KspC(self)
            KspC = self.calculate_K0(self.K_coefficients.K0,self.temperature+273.15,self.salinity);
        end
        function KspA = self_calculate_KspA(self)
            KspA = self.calculate_K0(self.K_coefficients.K0,self.temperature+273.15,self.salinity);
        end
        function KP1 = self_calculate_KP1(self)
            KP1 = self.calculate_K0(self.K_coefficients.K0,self.temperature+273.15,self.salinity);
        end
        function KP2 = self_calculate_KP2(self)
            KP2 = self.calculate_K0(self.K_coefficients.K0,self.temperature+273.15,self.salinity);
        end
        function KP3 = self_calculate_KP3(self)
            KP3 = self.calculate_K0(self.K_coefficients.K0,self.temperature+273.15,self.salinity);
        end

        function pressure_correction = self_pressure_correction(self,name)
            pressure_correction = self.calculate_pressure_correction(name,self.temperature,self.pressure);
        end
        function seawater_correction = self_seawater_correction(self,name)
            seawater_correction = self.calculate_seawater_correction(self,name,self.temperature,self.salinity,self.magnesium,self.calcium);
        end
    end
end