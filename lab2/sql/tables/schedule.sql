CREATE TABLE schedule (
    schedule_id SERIAL PRIMARY KEY,
    group_id INTEGER NOT NULL REFERENCES power_group(group_id),
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    CHECK (valid_from <= valid_to)
);
