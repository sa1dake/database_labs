CREATE TABLE address (
    address_id SERIAL PRIMARY KEY,
    district_id INTEGER NOT NULL REFERENCES district(district_id),
    street TEXT NOT NULL,
    building_number TEXT NOT NULL
);
