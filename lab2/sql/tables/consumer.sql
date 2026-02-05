CREATE TABLE consumer (
    consumer_id SERIAL PRIMARY KEY,
    address_id INTEGER NOT NULL REFERENCES address(address_id),
    group_id INTEGER NOT NULL REFERENCES power_group(group_id),
    consumer_type consumer_type NOT NULL
);
