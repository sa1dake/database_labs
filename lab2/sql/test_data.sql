INSERT INTO region (name, type) VALUES
('Kyiv', 'city'),
('Kyiv Region', 'region'),
('Lviv Region', 'region');

INSERT INTO district (region_id, name) VALUES
(1, 'Shevchenkivskyi'),
(1, 'Pecherskyi'),
(2, 'Brovary District'),
(2, 'Vyshhorod District'),
(3, 'Stryi District'),
(3, 'Drohobych District');

INSERT INTO address (district_id, street, building_number) VALUES
(1, 'Khreshchatyk', '10'),
(2, 'Heroes of Dnipro', '25A'),
(3, 'Centralna', '5');

INSERT INTO power_group (district_id, code) VALUES
(1, 'Group 1'),
(2, 'Group 2'),
(3, 'Group 3');

INSERT INTO schedule (group_id, valid_from, valid_to) VALUES
(1, '2025-01-01', '2025-03-31'),
(2, '2025-01-01', '2025-03-31'),
(3, '2025-01-01', '2025-03-31');

INSERT INTO time_slot (schedule_id, day_of_week, start_time, end_time) VALUES
(1, 1, '08:00', '12:00'),
(2, 3, '14:00', '18:00'),
(3, 5, '20:00', '23:00');

INSERT INTO consumer (address_id, group_id, consumer_type) VALUES
(1, 1, 'residential'),
(2, 2, 'business'),
(3, 3, 'critical');

INSERT INTO outage_event (group_id, start_datetime, end_datetime, reason) VALUES
(1, '2025-02-01 08:00', '2025-02-01 12:00', 'scheduled'),
(2, '2025-02-02 14:00', '2025-02-02 18:00', 'maintenance'),
(3, '2025-02-03 20:00', '2025-02-03 23:00', 'emergency');

INSERT INTO notification (event_id, message) VALUES
(1, 'Scheduled power outage'),
(2, 'Maintenance works ongoing'),
(3, 'Emergency power outage');