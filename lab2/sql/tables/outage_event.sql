CREATE TABLE outage_event (
    event_id SERIAL PRIMARY KEY,
    group_id INTEGER NOT NULL REFERENCES power_group(group_id),
    start_datetime TIMESTAMP NOT NULL,
    end_datetime TIMESTAMP NOT NULL,
    reason outage_reason NOT NULL,
    CHECK (start_datetime < end_datetime)
);
