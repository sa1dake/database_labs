-- Лабораторна робота 5: Оптимізована схема БД у 3НФ

-- Видалення таблиць у зворотному порядку залежностей
-- Для чистоти встановлення та уникнення помилок при повторному запуску
DROP TABLE IF EXISTS notification CASCADE;
DROP TABLE IF EXISTS outage_event CASCADE;
DROP TABLE IF EXISTS group_schedule_assignment CASCADE;
DROP TABLE IF EXISTS schedule_time_slot CASCADE;
DROP TABLE IF EXISTS schedule_template CASCADE;
DROP TABLE IF EXISTS consumer CASCADE;
DROP TABLE IF EXISTS address CASCADE;
DROP TABLE IF EXISTS power_group CASCADE;
DROP TABLE IF EXISTS district CASCADE;
DROP TABLE IF EXISTS region CASCADE;

-- Перелічувані типи (enum)
-- Припускається, що вони створені у попередніх лабораторних
-- Якщо ні — розкоментувати
-- CREATE TYPE region_type AS ENUM ('city', 'oblast');
-- CREATE TYPE consumer_type AS ENUM ('residential', 'business', 'critical');
-- CREATE TYPE outage_reason AS ENUM ('planned', 'emergency', 'weather');

-- 1. Адміністративна ієрархія
CREATE TABLE region (
    region_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    type region_type NOT NULL -- Дозволяє розрізняти правила для Києва та області
);


CREATE TABLE district (
    district_id SERIAL PRIMARY KEY,
    region_id INTEGER NOT NULL REFERENCES region(region_id),
    name TEXT NOT NULL
);


-- 2. Ієрархія електромереж
CREATE TABLE power_group (
    group_id SERIAL PRIMARY KEY,
    district_id INTEGER NOT NULL REFERENCES district(district_id),
    code TEXT NOT NULL
);


-- 3. Адреса
-- Підтримує 3НФ шляхом розділення відповідальностей:
-- district_id: адміністративне розташування
-- group_id: технічне підключення до електромережі
CREATE TABLE address (
    address_id SERIAL PRIMARY KEY,
    district_id INTEGER NOT NULL REFERENCES district(district_id),
    group_id INTEGER NOT NULL REFERENCES power_group(group_id),
    street TEXT NOT NULL,
    building_number TEXT NOT NULL
);


-- 4. Споживач
-- Нормалізовано: поле group_id прибрано (воно зберігається в address)
CREATE TABLE consumer (
    consumer_id SERIAL PRIMARY KEY,
    address_id INTEGER NOT NULL REFERENCES address(address_id),
    consumer_type consumer_type NOT NULL
);


-- 5. Оптимізована система графіків (шаблони)
CREATE TABLE schedule_template (
    template_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT
);


CREATE TABLE schedule_time_slot (
    slot_id SERIAL PRIMARY KEY,
    template_id INTEGER NOT NULL REFERENCES schedule_template(template_id),
    day_of_week INTEGER NOT NULL CHECK (day_of_week BETWEEN 1 AND 7),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    CHECK (start_time < end_time)
);

-- Призначає шаблон графіка групі на визначений період часу
CREATE TABLE group_schedule_assignment (
    assignment_id SERIAL PRIMARY KEY,
    group_id INTEGER NOT NULL REFERENCES power_group(group_id),
    template_id INTEGER NOT NULL REFERENCES schedule_template(template_id),
    valid_from DATE NOT NULL,
    valid_to DATE, -- NULL означає, що графік діє безстроково
    CHECK (valid_to IS NULL OR valid_from <= valid_to)
);

-- 6. Події відключень та сповіщення
CREATE TABLE outage_event (
    event_id SERIAL PRIMARY KEY,
    group_id INTEGER NOT NULL REFERENCES power_group(group_id),
    start_datetime TIMESTAMP NOT NULL,
    end_datetime TIMESTAMP NOT NULL,
    reason outage_reason NOT NULL,
    CHECK (start_datetime < end_datetime)
);

CREATE TABLE notification (
    notification_id SERIAL PRIMARY KEY,
    event_id INTEGER NOT NULL REFERENCES outage_event(event_id),
    message TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
