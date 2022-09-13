truncate table converter.response;
insert into converter.response (error_code, error_description) values
('CF000','Error! An unknown error occurred while performing this action.'),
('CF001','Error! Cannot input <NULL> values.'),
('CF002','Error! User does not have a default conversion set.'),
('CF003','Error! The supplied in_data_category_id does not exist.'),
('CF004','Error! The UOM for this data category is not set in the conversion set.'),
('CF005','Error! The supplied in_uom_name is not found in the UOM list.'),
('CF006','Error! The origin and destination UOMs are not of the same data type.'),
('CF007','Error! The supplied in_conversion_set does not exist.'),
('CF008','Error! The supplied out_oum_id does not exist.'),
('CF009','Error! The supplied in_uom_id does not exist.'),
('CF010','Error! The supplied in_uom_abbr does not exist.'),
('CF011','Error! The supplied destination_conversion_set_name already exists.'),
('CF012','Error! The supplied source_conversion_set_name does not exist.'),
('CF013','Error! The supplied in_conversion_set_name does not exist.'),
('CF014','Error! The supplied in_data_category_id does not exist.'),
('CF015','Error! The supplied in_data_type_id does not exist.'),
('CF016','Error! The supplied UOM already exists in this data type.'),
('CF017','Error! The supplied in_uom_name or in_uom_abbr already exists.'),
('CF018','Error! Boundary and UOM values must either be specified or both be null.'),
('CF019','Error! The UOM and boundary UOM are not of the same type.'),
('CF020','Error! The supplied boundary UOM does not exist.'),
('CF021','Error! The supplied data_type_name already exists.'),
('CF022','Error! The supplied in_data_type_name is not found in the Data Type list.'),
('CF023','Error! The supplied in_data_category_name already exists.'),
('CF024','Error! The supplied in_data_category_id has dependencies and cannot be disabled.'),
('CF025','Error! The supplied in_data_category_name is not found in the Data Category list.');