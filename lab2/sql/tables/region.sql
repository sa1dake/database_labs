CREATE TABLE region (
    region_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    type region_type NOT NULL
);
