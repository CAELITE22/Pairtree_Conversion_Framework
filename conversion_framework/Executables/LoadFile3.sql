--add types
SELECT converter.add_data_type(-1, 'angle')
;
SELECT converter.add_data_type(-1, 'fire_rating')
;
SELECT converter.add_data_type(-1, 'humidity')
;
SELECT converter.add_data_type(-1, 'length')
;
SELECT converter.add_data_type(-1, 'ozone')
;
SELECT converter.add_data_type(-1, 'percentage')
;
SELECT converter.add_data_type(-1, 'power_level')
;
SELECT converter.add_data_type(-1, 'pressure')
;
SELECT converter.add_data_type(-1, 'electric_conductivity')
;
SELECT converter.add_data_type(-1, 'solar_radiation')
;
SELECT converter.add_data_type(-1, 'speed')
;
SELECT converter.add_data_type(-1, 'temperature')
;
SELECT converter.add_data_type(-1, 'uv_index')
;
SELECT converter.add_data_type(-1, 'voltage')
;
SELECT converter.add_data_type(-1, 'volume')
;
SELECT converter.add_data_type(-1, 'mass')
;
SELECT converter.add_data_type(-1, 'area')
;
SELECT converter.add_data_type(-1, 'energy')
;
SELECT converter.add_data_type(-1, 'time')
;
SELECT converter.add_data_type(-1, 'electrical_current')
;
SELECT converter.add_data_type(-1, 'luminosity')
;
SELECT converter.add_data_type(-1, 'frequency')
;


--Add UOMs
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'angle')), 'miliradians', 'mrad',0.001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'angle')), 'degrees', '°',57.2958, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'angle')), 'radians', 'rad',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'angle')), 'gradians', 'grad',63.662, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'angle')), 'revolutions', 'rev',0.159155, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'area')), 'square centimetre', 'cm^2',100, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'area')), 'square metre', 'm^2',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'area')), 'square kilometre', 'km^2',0.001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'area')), 'hectare', 'ha',0.0001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'area')), 'square inch', 'sq. in',39.3701, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'area')), 'square foot', 'sq. ft',3.28084, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'area')), 'square yard', 'sq. yd',1.094, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'area')), 'acre', 'ac',0.000247105, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'area')), 'square mile', 'sq. mi',0.000621371, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'electrical_current')), 'micro-ampere', 'μA',1000000, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'electrical_current')), 'mili-ampere', 'mA',1000, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'electrical_current')), 'ampere', 'A',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'electrical_current')), 'kilo-ampere', 'kA',0.001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'electrical_current')), 'mega-ampere', 'MA',0.000001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')), 'deciSiemens per meter', 'dS/m',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')), 'millimhos per centimetre', 'mmhos/cm',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'energy')), 'joule', 'J',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'energy')), 'kilojoule', 'kJ',0.001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'energy')), 'megajoule', 'MJ',0.000001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'energy')), 'gigajoule', 'GJ',0.000000001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'energy')), 'kilocalorie', 'kCal',0.000238095, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'energy')), 'megacalorie', 'MCal',2.38095E-07, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'energy')), 'terajoule', 'TJ',1E-12, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'energy')), 'watt hours', 'Wh',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'energy')), 'kilowatt hours', 'kWh',0.001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'energy')), 'megawatt hours', 'mWh',0.000001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'frequency')), 'milihertz', 'mHz',1000, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'frequency')), 'Hertz', 'Hz',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'frequency')), 'kilohertz', 'kHz',0.001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'frequency')), 'megahertz', 'MHz',0.000001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'frequency')), 'gigahertz', 'gHz',0.000000001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'humidity')), 'grams per cubic meter', 'g/m³',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'length')), 'millimetres', 'mm',1000, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'length')), 'centimetres', 'cm',100, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'length')), 'metres', 'm',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'length')), 'kilometres', 'km',0.001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'length')), 'inches', 'in',39.3701, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'length')), 'foot', 'ft',3.28084, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'length')), 'yards', 'yd',1.094, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'length')), 'furlong', 'fl',0.00497097, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'length')), 'miles', 'mi',0.000621371, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'length')), 'nautical miles', 'nmi',0.000539957, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'luminosity')), 'candela', 'cd',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'luminosity')), 'lumen', 'lm',12.57, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'mass')), 'milligram', 'mg',1000000, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'mass')), 'gram', 'gr',1000, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'mass')), 'kilogram', 'kg',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'mass')), 'tonne', 't',0.001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'mass')), 'megatonne', 'MT',0.000001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'mass')), 'ounce', 'oz',35.274, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'mass')), 'pound', 'lb',2.205, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'mass')), 'stone', 'st',0.157473, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'ozone')), 'dobson unit', 'DU',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'percentage')), 'percent', '%',0, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'percentage')), 'decimal', '?',0.01, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'power_level')), 'decibel-milliwatt', 'dBm',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'power_level')), 'milliwatt', 'mW',1000, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'power_level')), 'watt', 'W',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'power_level')), 'kilowatt', 'kW',0.001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'power_level')), 'megawatt', 'MW',0.000001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'pressure')), 'millipascal', 'mPa',1000, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'pressure')), 'pascal', 'Pa',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'pressure')), 'hectopascals', 'hPa',0.01, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'pressure')), 'pounds per square inch', 'psi',0.000145038, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'pressure')), 'kilopascals', 'kPa',0.001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'pressure')), 'bar', 'bar',0.000001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'solar_radiation')), 'Watts per square metre', 'W/m2',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'speed')), 'metres per hour', 'm/h',3600, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'speed')), 'kilometres per hour', 'km/h',3.6, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'speed')), 'metres per second', 'm/s',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'speed')), 'yards per secord', 'yd/s',1.094, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'speed')), 'yards per hour', 'yd/h',3937.007, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'speed')), 'miles per hour', 'mi/h',2.23694, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'speed')), 'knots', 'knot',1.94384, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'temperature')), 'celsius', '°C',1, -273.15)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'temperature')), 'kelvin', '°K',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'temperature')), 'fahrenheit', '°F',1.8, -459.67)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'temperature')), 'rankine', '°Ra',1.8, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'time')), 'seconds', 'sec',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'time')), 'minutes', 'min',0.016666667, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'time')), 'hours', 'hrs',0.000277778, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'time')), 'days', 'days',1.15741E-05, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'time')), 'weeks', 'wks',1.65343E-06, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'time')), 'years', 'yrs',1/220752000, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'voltage')), 'volt', 'V',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'voltage')), 'kilovolt', 'kV',0.001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'voltage')), 'megavolt', 'MV',0.000001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'milliliter', 'ml',1000000, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'cubic centimetres', 'cm3',1000000, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'liter', 'L',1000, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'cubic metres', 'm3',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'kiloliter', 'kL',1, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'megaliter', 'ML',0.001, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'teaspoon', 'tsp',202884, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'tablespoon', 'tbsp',67628, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'fluid ounce', 'fl. oz',33814, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'cup', 'c',4227, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'pint', 'pt',2113.38, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'quart', 'qt',1056.69, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'gallon', 'gal',264.172, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'cubic inch', 'cu in',61023.7, 0)
;
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'cubic foot', 'cu ft',35.3147, 0)
;

--Add Data Catergories
SELECT converter.add_data_category(-1, 'Wind Direction', (SELECT converter.get_data_type_id_from_name(-1,'angle')))
;
SELECT converter.add_data_category(-1, 'Fire Danger Index', (SELECT converter.get_data_type_id_from_name(-1,'fire_rating')))
;
SELECT converter.add_data_category(-1, 'Absolute Humidity', (SELECT converter.get_data_type_id_from_name(-1,'humidity')))
;
SELECT converter.add_data_category(-1, 'Height', (SELECT converter.get_data_type_id_from_name(-1,'length')))
;
SELECT converter.add_data_category(-1, 'ETo', (SELECT converter.get_data_type_id_from_name(-1,'length')))
;
SELECT converter.add_data_category(-1, 'Rainfall', (SELECT converter.get_data_type_id_from_name(-1,'length')))
;
SELECT converter.add_data_category(-1, 'Visibilty', (SELECT converter.get_data_type_id_from_name(-1,'length')))
;
SELECT converter.add_data_category(-1, 'Ozone', (SELECT converter.get_data_type_id_from_name(-1,'ozone')))
;
SELECT converter.add_data_category(-1, 'Soil Moisture', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
;
SELECT converter.add_data_category(-1, 'Soil Moisture 010 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
;
SELECT converter.add_data_category(-1, 'Soil Moisture 020 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
;
SELECT converter.add_data_category(-1, 'Soil Moisture 030 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
;
SELECT converter.add_data_category(-1, 'Soil Moisture 040 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
;
SELECT converter.add_data_category(-1, 'Pecentage Full', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
;
SELECT converter.add_data_category(-1, 'Relative Humidity', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
;
SELECT converter.add_data_category(-1, 'Leaf Wetness', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
;
SELECT converter.add_data_category(-1, 'Cloud Cover', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
;
SELECT converter.add_data_category(-1, 'Rainfall Probability', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
;
SELECT converter.add_data_category(-1, 'Soil Moisture 050 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
;
SELECT converter.add_data_category(-1, 'Soil Moisture 060 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
;
SELECT converter.add_data_category(-1, 'Soil Moisture 070 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
;
SELECT converter.add_data_category(-1, 'Soil Moisture 080 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
;
SELECT converter.add_data_category(-1, 'Soil Moisture 090 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
;
SELECT converter.add_data_category(-1, 'Soil Moisture 100 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
;
SELECT converter.add_data_category(-1, 'Soil Moisture 110 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
;
SELECT converter.add_data_category(-1, 'Soil Moisture 120 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
;
SELECT converter.add_data_category(-1, 'Soil Moisture 130 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
;
SELECT converter.add_data_category(-1, 'Signal Strength', (SELECT converter.get_data_type_id_from_name(-1,'power_level')))
;
SELECT converter.add_data_category(-1, 'Barometric Pressure', (SELECT converter.get_data_type_id_from_name(-1,'pressure')))
;
SELECT converter.add_data_category(-1, 'Vapour Pressure', (SELECT converter.get_data_type_id_from_name(-1,'pressure')))
;
SELECT converter.add_data_category(-1, 'Vapour Pressure Deficit', (SELECT converter.get_data_type_id_from_name(-1,'pressure')))
;
SELECT converter.add_data_category(-1, 'Soil Salinity 010 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
;
SELECT converter.add_data_category(-1, 'Soil Salinity 020 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
;
SELECT converter.add_data_category(-1, 'Soil Salinity 030 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
;
SELECT converter.add_data_category(-1, 'Soil Salinity 040 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
;
SELECT converter.add_data_category(-1, 'Soil Salinity 050 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
;
SELECT converter.add_data_category(-1, 'Soil Salinity 060 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
;
SELECT converter.add_data_category(-1, 'Soil Salinity 070 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
;
SELECT converter.add_data_category(-1, 'Soil Salinity 080 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
;
SELECT converter.add_data_category(-1, 'Soil Salinity 090 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
;
SELECT converter.add_data_category(-1, 'Soil Salinity 100 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
;
SELECT converter.add_data_category(-1, 'Soil Salinity 110 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
;
SELECT converter.add_data_category(-1, 'Soil Salinity 120 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
;
SELECT converter.add_data_category(-1, 'Soil Salinity 130 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
;
SELECT converter.add_data_category(-1, 'Solar Radiation', (SELECT converter.get_data_type_id_from_name(-1,'solar_radiation')))
;
SELECT converter.add_data_category(-1, 'Wind Speed', (SELECT converter.get_data_type_id_from_name(-1,'speed')))
;
SELECT converter.add_data_category(-1, 'Wind Speed Max', (SELECT converter.get_data_type_id_from_name(-1,'speed')))
;
SELECT converter.add_data_category(-1, 'Wind Speed Min', (SELECT converter.get_data_type_id_from_name(-1,'speed')))
;
SELECT converter.add_data_category(-1, 'Rainfall Rate', (SELECT converter.get_data_type_id_from_name(-1,'speed')))
;
SELECT converter.add_data_category(-1, 'Soil Temperature', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
;
SELECT converter.add_data_category(-1, 'Air Temperature', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
;
SELECT converter.add_data_category(-1, 'DeltaT', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
;
SELECT converter.add_data_category(-1, 'Dew Point', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
;
SELECT converter.add_data_category(-1, 'Apparent Temperature', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
;
SELECT converter.add_data_category(-1, 'Soil Temperature 010 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
;
SELECT converter.add_data_category(-1, 'Soil Temperature 020 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
;
SELECT converter.add_data_category(-1, 'Soil Temperature 030 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
;
SELECT converter.add_data_category(-1, 'Soil Temperature 040 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
;
SELECT converter.add_data_category(-1, 'Soil Temperature 050 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
;
SELECT converter.add_data_category(-1, 'Soil Temperature 060 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
;
SELECT converter.add_data_category(-1, 'Soil Temperature 070 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
;
SELECT converter.add_data_category(-1, 'Soil Temperature 080 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
;
SELECT converter.add_data_category(-1, 'Soil Temperature 090 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
;
SELECT converter.add_data_category(-1, 'Soil Temperature 100 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
;
SELECT converter.add_data_category(-1, 'Soil Temperature 110 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
;
SELECT converter.add_data_category(-1, 'Soil Temperature 120 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
;
SELECT converter.add_data_category(-1, 'Soil Temperature 130 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
;
SELECT converter.add_data_category(-1, 'UV', (SELECT converter.get_data_type_id_from_name(-1,'uv_index')))
;
SELECT converter.add_data_category(-1, 'Battery Voltage', (SELECT converter.get_data_type_id_from_name(-1,'voltage')))
;
SELECT converter.add_data_category(-1, 'Current Volume', (SELECT converter.get_data_type_id_from_name(-1,'volume')));--add conversion sets

SELECT converter.add_conversion_set(-1,'Metric')
UNION ALL
SELECT converter.add_conversion_set(-1,'Imperial');


--add default users for some testing
SELECT converter.set_user_conversion_set(-1, converter.get_conversion_set_id_from_name(-1,'Metric'))
UNION ALL
SELECT converter.set_user_conversion_set(-2, converter.get_conversion_set_id_from_name(-1,'Imperial'));

--add category-uom mapping for conversion sets
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Wind Direction')), (SELECT converter.get_uom_id_from_name(-1,'degrees')));
--SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Fire Danger Index')), (SELECT converter.get_uom_id_from_name(-1,'index')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Absolute Humidity')), (SELECT converter.get_uom_id_from_name(-1,'grams per cubic meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Height')), (SELECT converter.get_uom_id_from_name(-1,'millimetres')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'ETo')), (SELECT converter.get_uom_id_from_name(-1,'millimetres')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Rainfall')), (SELECT converter.get_uom_id_from_name(-1,'millimetres')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Visibilty')), (SELECT converter.get_uom_id_from_name(-1,'kilometres')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Ozone')), (SELECT converter.get_uom_id_from_name(-1,'dobson unit')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 010 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 020 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 030 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 040 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Pecentage Full')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Relative Humidity')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Leaf Wetness')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Cloud Cover')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Rainfall Probability')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 050 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 060 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 070 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 080 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 090 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 100 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 110 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 120 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 130 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Signal Strength')), (SELECT converter.get_uom_id_from_name(-1,'decibel-milliwatt')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Barometric Pressure')), (SELECT converter.get_uom_id_from_name(-1,'hectopascals')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Vapour Pressure')), (SELECT converter.get_uom_id_from_name(-1,'kilopascals')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Vapour Pressure Deficit')), (SELECT converter.get_uom_id_from_name(-1,'kilopascals')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 010 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 020 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 030 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 040 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 050 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 060 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 070 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 080 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 090 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 100 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 110 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 120 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 130 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Solar Radiation')), (SELECT converter.get_uom_id_from_name(-1,'Watts per square metre')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Wind Speed')), (SELECT converter.get_uom_id_from_name(-1,'kilometres per hour')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Wind Speed Max')), (SELECT converter.get_uom_id_from_name(-1,'kilometres per hour')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Wind Speed Min')), (SELECT converter.get_uom_id_from_name(-1,'kilometres per hour')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Rainfall Rate')), (SELECT converter.get_uom_id_from_name(-1,'kilometres per hour')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature')), (SELECT converter.get_uom_id_from_name(-1,'celsius')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Air Temperature')), (SELECT converter.get_uom_id_from_name(-1,'celsius')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'DeltaT')), (SELECT converter.get_uom_id_from_name(-1,'celsius')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Dew Point')), (SELECT converter.get_uom_id_from_name(-1,'celsius')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Apparent Temperature')), (SELECT converter.get_uom_id_from_name(-1,'celsius')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 010 cm')), (SELECT converter.get_uom_id_from_name(-1,'celsius')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 020 cm')), (SELECT converter.get_uom_id_from_name(-1,'celsius')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 030 cm')), (SELECT converter.get_uom_id_from_name(-1,'celsius')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 040 cm')), (SELECT converter.get_uom_id_from_name(-1,'celsius')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 050 cm')), (SELECT converter.get_uom_id_from_name(-1,'celsius')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 060 cm')), (SELECT converter.get_uom_id_from_name(-1,'celsius')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 070 cm')), (SELECT converter.get_uom_id_from_name(-1,'celsius')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 080 cm')), (SELECT converter.get_uom_id_from_name(-1,'celsius')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 090 cm')), (SELECT converter.get_uom_id_from_name(-1,'celsius')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 100 cm')), (SELECT converter.get_uom_id_from_name(-1,'celsius')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 110 cm')), (SELECT converter.get_uom_id_from_name(-1,'celsius')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 120 cm')), (SELECT converter.get_uom_id_from_name(-1,'celsius')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 130 cm')), (SELECT converter.get_uom_id_from_name(-1,'celsius')));
-- SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'UV')), (SELECT converter.get_uom_id_from_name(-1,'index')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Battery Voltage')), (SELECT converter.get_uom_id_from_name(-1,'volt')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Metric')), (SELECT converter.get_data_category_id_from_name(-1,'Current Volume')), (SELECT converter.get_uom_id_from_name(-1,'liter')));

SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Wind Direction')), (SELECT converter.get_uom_id_from_name(-1,'degrees')));
-- SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Fire Danger Index')), (SELECT converter.get_uom_id_from_name(-1,'index')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Absolute Humidity')), (SELECT converter.get_uom_id_from_name(-1,'grams per cubic meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Height')), (SELECT converter.get_uom_id_from_name(-1,'inches')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'ETo')), (SELECT converter.get_uom_id_from_name(-1,'inches')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Rainfall')), (SELECT converter.get_uom_id_from_name(-1,'inches')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Visibilty')), (SELECT converter.get_uom_id_from_name(-1,'miles')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Ozone')), (SELECT converter.get_uom_id_from_name(-1,'dobson unit')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 010 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 020 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 030 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 040 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Pecentage Full')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Relative Humidity')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Leaf Wetness')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Cloud Cover')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Rainfall Probability')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 050 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 060 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 070 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 080 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 090 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 100 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 110 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 120 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Moisture 130 cm')), (SELECT converter.get_uom_id_from_name(-1,'percent')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Signal Strength')), (SELECT converter.get_uom_id_from_name(-1,'decibel-milliwatt')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Barometric Pressure')), (SELECT converter.get_uom_id_from_name(-1,'pounds per square inch')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Vapour Pressure')), (SELECT converter.get_uom_id_from_name(-1,'pounds per square inch')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Vapour Pressure Deficit')), (SELECT converter.get_uom_id_from_name(-1,'pounds per square inch')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 010 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 020 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 030 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 040 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 050 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 060 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 070 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 080 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 090 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 100 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 110 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 120 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Salinity 130 cm')), (SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Solar Radiation')), (SELECT converter.get_uom_id_from_name(-1,'Watts per square metre')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Wind Speed')), (SELECT converter.get_uom_id_from_name(-1,'miles per hour')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Wind Speed Max')), (SELECT converter.get_uom_id_from_name(-1,'miles per hour')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Wind Speed Min')), (SELECT converter.get_uom_id_from_name(-1,'miles per hour')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Rainfall Rate')), (SELECT converter.get_uom_id_from_name(-1,'miles per hour')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature')), (SELECT converter.get_uom_id_from_name(-1,'fahrenheit')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Air Temperature')), (SELECT converter.get_uom_id_from_name(-1,'fahrenheit')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'DeltaT')), (SELECT converter.get_uom_id_from_name(-1,'fahrenheit')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Dew Point')), (SELECT converter.get_uom_id_from_name(-1,'fahrenheit')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Apparent Temperature')), (SELECT converter.get_uom_id_from_name(-1,'fahrenheit')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 010 cm')), (SELECT converter.get_uom_id_from_name(-1,'fahrenheit')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 020 cm')), (SELECT converter.get_uom_id_from_name(-1,'fahrenheit')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 030 cm')), (SELECT converter.get_uom_id_from_name(-1,'fahrenheit')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 040 cm')), (SELECT converter.get_uom_id_from_name(-1,'fahrenheit')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 050 cm')), (SELECT converter.get_uom_id_from_name(-1,'fahrenheit')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 060 cm')), (SELECT converter.get_uom_id_from_name(-1,'fahrenheit')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 070 cm')), (SELECT converter.get_uom_id_from_name(-1,'fahrenheit')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 080 cm')), (SELECT converter.get_uom_id_from_name(-1,'fahrenheit')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 090 cm')), (SELECT converter.get_uom_id_from_name(-1,'fahrenheit')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 100 cm')), (SELECT converter.get_uom_id_from_name(-1,'fahrenheit')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 110 cm')), (SELECT converter.get_uom_id_from_name(-1,'fahrenheit')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 120 cm')), (SELECT converter.get_uom_id_from_name(-1,'fahrenheit')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Soil Temperature 130 cm')), (SELECT converter.get_uom_id_from_name(-1,'fahrenheit')));
-- SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'UV')), (SELECT converter.get_uom_id_from_name(-1,'index')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Battery Voltage')), (SELECT converter.get_uom_id_from_name(-1,'volt')));
SELECT converter.update_target_conversion_set_category_uom(-1, (SELECT converter.get_conversion_set_id_from_name(-1,'Imperial')), (SELECT converter.get_data_category_id_from_name(-1,'Current Volume')), (SELECT converter.get_uom_id_from_name(-1,'fluid ounce')));
