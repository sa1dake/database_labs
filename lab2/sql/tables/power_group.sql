CREATE TABLE power_group (
    group_id SERIAL PRIMARY KEY,
    district_id INTEGER NOT NULL REFERENCES district(district_id),
    code TEXT NOT NULL
);
