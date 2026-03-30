-- ENUM типи
CREATE TYPE project_status AS ENUM ('open', 'closed');
CREATE TYPE contract_status AS ENUM ('in_progress', 'completed');

-- Клієнти
CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    company_name VARCHAR(100),
    contact_email VARCHAR(100)
);

-- Фрілансери
CREATE TABLE freelancers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    skills TEXT,
    hourly_rate DECIMAL(10,2)
);

-- Категорії
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

-- Проекти
CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    client_id INT REFERENCES clients(id),
    category_id INT REFERENCES categories(id),
    title VARCHAR(100),
    description TEXT,
    budget DECIMAL(10,2),
    deadline DATE,
    status project_status
);

-- Пропозиції
CREATE TABLE proposals (
    id SERIAL PRIMARY KEY,
    project_id INT REFERENCES projects(id),
    freelancer_id INT REFERENCES freelancers(id),
    bid_amount DECIMAL(10,2),
    created_at DATE
);

-- Контракти
CREATE TABLE contracts (
    id SERIAL PRIMARY KEY,
    proposal_id INT REFERENCES proposals(id),
    start_date DATE,
    end_date DATE,
    status contract_status
);

-- Платежі
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    contract_id INT REFERENCES contracts(id),
    amount DECIMAL(10,2),
    payment_date DATE
);
