--add types
SELECT converter.add_data_type(-1, 'angle')
UNION ALL
SELECT converter.add_data_type(-1, 'fire_rating')
UNION ALL
SELECT converter.add_data_type(-1, 'humidity')
UNION ALL
SELECT converter.add_data_type(-1, 'length')
UNION ALL
SELECT converter.add_data_type(-1, 'ozone')
UNION ALL
SELECT converter.add_data_type(-1, 'percentage')
UNION ALL
SELECT converter.add_data_type(-1, 'power_level')
UNION ALL
SELECT converter.add_data_type(-1, 'pressure')
UNION ALL
SELECT converter.add_data_type(-1, 'electric_conductivity')
UNION ALL
SELECT converter.add_data_type(-1, 'solar_radiation')
UNION ALL
SELECT converter.add_data_type(-1, 'speed')
UNION ALL
SELECT converter.add_data_type(-1, 'temperature')
UNION ALL
SELECT converter.add_data_type(-1, 'uv_index')
UNION ALL
SELECT converter.add_data_type(-1, 'voltage')
UNION ALL
SELECT converter.add_data_type(-1, 'volume')
UNION ALL
SELECT converter.add_data_type(-1, 'mass')
UNION ALL
SELECT converter.add_data_type(-1, 'area')
UNION ALL
SELECT converter.add_data_type(-1, 'energy')
UNION ALL
SELECT converter.add_data_type(-1, 'time')
UNION ALL
SELECT converter.add_data_type(-1, 'electrical_current')
UNION ALL
SELECT converter.add_data_type(-1, 'luminosity')
UNION ALL
SELECT converter.add_data_type(-1, 'frequency');



--Add UOMs
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'angle')), 'miliradians', 'mrad')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'angle')), 'degrees', '°')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'angle')), 'radians', 'rad')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'angle')), 'gradians', 'grad')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'angle')), 'revolutions', 'rev')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'area')), 'square centimetre', 'cm^2')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'area')), 'square metre', 'm^2')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'area')), 'square kilometre', 'km^2')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'area')), 'hectare', 'ha')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'area')), 'square inch', 'sq. in')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'area')), 'square foot', 'sq. ft')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'area')), 'square yard', 'sq. yd')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'area')), 'acre', 'ac')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'area')), 'square mile', 'sq. mi')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'electrical_current')), 'micro-ampere', 'μA')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'electrical_current')), 'mili-ampere', 'mA')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'electrical_current')), 'ampere', 'A')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'electrical_current')), 'kilo-ampere', 'kA')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'electrical_current')), 'mega-ampere', 'MA')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')), 'deciSiemens per meter', 'dS/m')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')), 'millimhos per centimetre', 'mmhos/cm')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'energy')), 'joule', 'J')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'energy')), 'kilojoule', 'kJ')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'energy')), 'megajoule', 'MJ')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'energy')), 'gigajoule', 'GJ')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'energy')), 'kilocalorie', 'kCal')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'energy')), 'megacalorie', 'MCal')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'energy')), 'terajoule', 'TJ')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'energy')), 'watt hours', 'Wh')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'energy')), 'kilowatt hours', 'kWh')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'energy')), 'megawatt hours', 'mWh')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'frequency')), 'milihertz', 'mHz')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'frequency')), 'Hertz', 'Hz')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'frequency')), 'kilohertz', 'kHz')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'frequency')), 'megahertz', 'MHz')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'frequency')), 'gigahertz', 'gHz')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'humidity')), 'grams per cubic meter', 'g/m³')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'length')), 'millimetres', 'mm')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'length')), 'centimetres', 'cm')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'length')), 'metres', 'm')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'length')), 'kilometres', 'km')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'length')), 'inches', 'in')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'length')), 'foot', 'ft')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'length')), 'yards', 'yd')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'length')), 'furlong', 'fl')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'length')), 'miles', 'mi')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'length')), 'nautical miles', 'nmi')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'luminosity')), 'candela', 'cd')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'luminosity')), 'lumen', 'lm')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'mass')), 'milligram', 'mg')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'mass')), 'gram', 'gr')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'mass')), 'kilogram', 'kg')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'mass')), 'tonne', 't')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'mass')), 'megatonne', 'MT')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'mass')), 'ounce', 'oz')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'mass')), 'pound', 'lb')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'mass')), 'stone', 'st')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'ozone')), 'dobson unit', 'DU')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'percentage')), 'percent', '%')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'percentage')), 'decimal', '?')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'power_level')), 'decibel-milliwatt', 'dBm')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'power_level')), 'milliwatt', 'mW')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'power_level')), 'watt', 'W')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'power_level')), 'kilowatt', 'kW')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'power_level')), 'megawatt', 'MW')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'pressure')), 'millipascal', 'mPa')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'pressure')), 'pascal', 'Pa')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'pressure')), 'hectopascals', 'hPa')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'pressure')), 'pounds per square inch', 'psi')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'pressure')), 'kilopascals', 'kPa')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'pressure')), 'bar', 'bar')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'solar_radiation')), 'Watts per square metre', 'W/m2')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'speed')), 'metres per hour', 'm/h')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'speed')), 'kilometres per hour', 'km/h')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'speed')), 'metres per second', 'm/s')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'speed')), 'yards per secord', 'yd/s')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'speed')), 'yards per hour', 'yd/h')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'speed')), 'miles per hour', 'mi/h')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'speed')), 'knots', 'knot')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'temperature')), 'celsius', '°C')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'temperature')), 'kelvin', '°K')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'temperature')), 'fahrenheit', '°F')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'temperature')), 'rankine', '°Ra')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'time')), 'seconds', 'sec')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'time')), 'minutes', 'min')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'time')), 'hours', 'hrs')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'time')), 'days', 'days')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'time')), 'weeks', 'wks')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'time')), 'years', 'yrs')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'voltage')), 'volt', 'V')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'voltage')), 'kilovolt', 'kV')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'voltage')), 'megavolt', 'MV')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'milliliter', 'ml')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'cubic centimetres', 'cm3')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'liter', 'L')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'cubic metres', 'm3')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'kiloliter', 'kL')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'megaliter', 'ML')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'teaspoon', 'tsp')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'tablespoon', 'tbsp')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'fluid ounce', 'fl. oz')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'cup', 'c')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'pint', 'pt')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'quart', 'qt')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'gallon', 'gal')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'cubic inch', 'cu in')
UNION ALL
SELECT converter.add_uom(-1, (SELECT converter.get_data_type_id_from_name(-1,'volume')), 'cubic foot', 'cu ft');

INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'miliradians')),0.001, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'degrees')),57.2958, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'radians')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'gradians')),63.662, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'revolutions')),0.159155, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'square centimetre')),100, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'square metre')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'square kilometre')),0.001, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'hectare')),0.0001, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'square inch')),39.3701, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'square foot')),3.28084, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'square yard')),1.094, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'acre')),0.000247105, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'square mile')),0.000621371, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'micro-ampere')),1000000, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'mili-ampere')),1000, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'ampere')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'kilo-ampere')),0.001, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'mega-ampere')),0.000001, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'deciSiemens per meter')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'millimhos per centimetre')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'joule')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'kilojoule')),0.001, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'megajoule')),0.000001, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'gigajoule')),0.000000001, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'kilocalorie')),0.000238095, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'megacalorie')),2.38095E-07, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'terajoule')),1E-12, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'watt hours')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'kilowatt hours')),0.001, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'megawatt hours')),0.000001, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'milihertz')),1000, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'Hertz')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'kilohertz')),0.001, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'megahertz')),0.000001, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'gigahertz')),0.000000001, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'grams per cubic meter')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'millimetres')),1000, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'centimetres')),100, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'metres')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'kilometres')),0.001, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'inches')),39.3701, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'foot')),3.28084, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'yards')),1.094, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'furlong')),0.00497097, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'miles')),0.000621371, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'nautical miles')),0.000539957, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'candela')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'lumen')),12.57, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'milligram')),1000000, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'gram')),1000, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'kilogram')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'tonne')),0.001, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'megatonne')),0.000001,0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'ounce')),35.274, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'pound')),2.205, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'stone')),0.157473, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'dobson unit')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'percent')),0, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'decimal')),0.01, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'decibel-milliwatt')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'milliwatt')),1000, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'watt')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'kilowatt')),0.001, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'megawatt')),0.000001, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'millipascal')),1000, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'pascal')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'hectopascals')),0.01, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'pounds per square inch')),0.000145038, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'kilopascals')),0.001, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'bar')),0.000001, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'Watts per square metre')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'metres per hour')),3600, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'kilometres per hour')),3.6, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'metres per second')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'yards per secord')),1.094, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'yards per hour')),3937.007, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'miles per hour')),2.23694, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'knots')),1.94384, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'celsius')),1, -273.15, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'kelvin')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'fahrenheit')),1.8, -459.67, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'rankine')),1.8, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'seconds')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'minutes')),0.016666667, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'hours')),0.000277778, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'days')),1.15741E-05, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'weeks')),1.65343E-06, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'years')),1/220752000, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'volt')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'kilovolt')),0.001, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'megavolt')),0.000001, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'milliliter')),1000000, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'cubic centimetres')),1000000, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'liter')),1000, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'cubic metres')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'kiloliter')),1, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'megaliter')),0.001, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'teaspoon')),202884, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'tablespoon')),67628, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'fluid ounce')),33814, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'cup')),4227, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'pint')),2113.38, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'quart')),1056.69, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'gallon')),264.172, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'cubic inch')),61023.7, 0, now(), now(), -1, -1, TRUE);
INSERT INTO converter.conversion_rate(uom_id, rate, constant, created, updated, created_by,updated_by, active) VALUES ((SELECT converter.get_uom_id_from_name(-1,'cubic foot')),35.3147, 0, now(), now(), -1, -1, TRUE);

--Add data categories
SELECT converter.add_data_category(-1, 'Wind Direction', (SELECT converter.get_data_type_id_from_name(-1,'angle')))
UNION ALL
SELECT converter.add_data_category(-1, 'Fire Danger Index', (SELECT converter.get_data_type_id_from_name(-1,'fire_rating')))
UNION ALL
SELECT converter.add_data_category(-1, 'Absolute Humidity', (SELECT converter.get_data_type_id_from_name(-1,'humidity')))
UNION ALL
SELECT converter.add_data_category(-1, 'Height', (SELECT converter.get_data_type_id_from_name(-1,'length')))
UNION ALL
SELECT converter.add_data_category(-1, 'ETo', (SELECT converter.get_data_type_id_from_name(-1,'length')))
UNION ALL
SELECT converter.add_data_category(-1, 'Rainfall', (SELECT converter.get_data_type_id_from_name(-1,'length')))
UNION ALL
SELECT converter.add_data_category(-1, 'Visibilty', (SELECT converter.get_data_type_id_from_name(-1,'length')))
UNION ALL
SELECT converter.add_data_category(-1, 'Ozone', (SELECT converter.get_data_type_id_from_name(-1,'ozone')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Moisture', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Moisture 010 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Moisture 020 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Moisture 030 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Moisture 040 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
UNION ALL
SELECT converter.add_data_category(-1, 'Pecentage Full', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
UNION ALL
SELECT converter.add_data_category(-1, 'Relative Humidity', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
UNION ALL
SELECT converter.add_data_category(-1, 'Leaf Wetness', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
UNION ALL
SELECT converter.add_data_category(-1, 'Cloud Cover', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
UNION ALL
SELECT converter.add_data_category(-1, 'Rainfall Probability', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Moisture 050 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Moisture 060 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Moisture 070 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Moisture 080 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Moisture 090 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Moisture 100 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Moisture 110 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Moisture 120 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Moisture 130 cm', (SELECT converter.get_data_type_id_from_name(-1,'percentage')))
UNION ALL
SELECT converter.add_data_category(-1, 'Signal Strength', (SELECT converter.get_data_type_id_from_name(-1,'power_level')))
UNION ALL
SELECT converter.add_data_category(-1, 'Barometric Pressure', (SELECT converter.get_data_type_id_from_name(-1,'pressure')))
UNION ALL
SELECT converter.add_data_category(-1, 'Vapour Pressure', (SELECT converter.get_data_type_id_from_name(-1,'pressure')))
UNION ALL
SELECT converter.add_data_category(-1, 'Vapour Pressure Deficit', (SELECT converter.get_data_type_id_from_name(-1,'pressure')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Salinity 010 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Salinity 020 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Salinity 030 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Salinity 040 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Salinity 050 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Salinity 060 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Salinity 070 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Salinity 080 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Salinity 090 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Salinity 100 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Salinity 110 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Salinity 120 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Salinity 130 cm', (SELECT converter.get_data_type_id_from_name(-1,'electric_conductivity')))
UNION ALL
SELECT converter.add_data_category(-1, 'Solar Radiation', (SELECT converter.get_data_type_id_from_name(-1,'solar_radiation')))
UNION ALL
SELECT converter.add_data_category(-1, 'Wind Speed', (SELECT converter.get_data_type_id_from_name(-1,'speed')))
UNION ALL
SELECT converter.add_data_category(-1, 'Wind Speed Max', (SELECT converter.get_data_type_id_from_name(-1,'speed')))
UNION ALL
SELECT converter.add_data_category(-1, 'Wind Speed Min', (SELECT converter.get_data_type_id_from_name(-1,'speed')))
UNION ALL
SELECT converter.add_data_category(-1, 'Rainfall Rate', (SELECT converter.get_data_type_id_from_name(-1,'speed')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Temperature', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
UNION ALL
SELECT converter.add_data_category(-1, 'Air Temperature', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
UNION ALL
SELECT converter.add_data_category(-1, 'DeltaT', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
UNION ALL
SELECT converter.add_data_category(-1, 'Dew Point', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
UNION ALL
SELECT converter.add_data_category(-1, 'Apparent Temperature', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Temperature 010 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Temperature 020 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Temperature 030 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Temperature 040 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Temperature 050 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Temperature 060 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Temperature 070 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Temperature 080 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Temperature 090 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Temperature 100 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Temperature 110 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Temperature 120 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
UNION ALL
SELECT converter.add_data_category(-1, 'Soil Temperature 130 cm', (SELECT converter.get_data_type_id_from_name(-1,'temperature')))
UNION ALL
SELECT converter.add_data_category(-1, 'UV', (SELECT converter.get_data_type_id_from_name(-1,'uv_index')))
UNION ALL
SELECT converter.add_data_category(-1, 'Battery Voltage', (SELECT converter.get_data_type_id_from_name(-1,'voltage')))
UNION ALL
SELECT converter.add_data_category(-1, 'Current Volume', (SELECT converter.get_data_type_id_from_name(-1,'volume')));