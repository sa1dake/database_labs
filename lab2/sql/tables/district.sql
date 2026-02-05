CREATE TABLE district (
    district_id SERIAL PRIMARY KEY,
    region_id INTEGER NOT NULL REFERENCES region(region_id),
    name TEXT NOT NULL
);
