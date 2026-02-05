CREATE TABLE notification (
    notification_id SERIAL PRIMARY KEY,
    event_id INTEGER NOT NULL REFERENCES outage_event(event_id),
    message TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
