--add conversion sets

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
