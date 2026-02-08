const { Client } = require('pg');

const client = new Client({
  connectionString: 'postgresql://postgres:password123@localhost:5432/postgres'
});

async function main() {
    console.log('--- Підключення до бази даних (PostgreSQL) ---');
    await client.connect();

    try {
        console.log('--- Перевірка існування таблиці review ---');
        const checkTable = await client.query(`
            SELECT EXISTS (
                SELECT FROM information_schema.tables
                WHERE table_name = 'review'
            );
        `);
        console.log('Таблиця review існує:', checkTable.rows[0].exists);

        if (checkTable.rows[0].exists) {
            console.log('\n--- Очистка таблиці review перед тестом ---');
            await client.query('DELETE FROM review;');

            console.log('--- Вставка даних у review ---');
            // Припускаємо, що у вас є consumer_id = 1. Якщо ні, то це впаде.
            // Щоб уникнути цього, давайте спочатку отримаємо або створимо споживача.

            // 1. Отримати або створити споживача
            let consumerId;
            const consumers = await client.query('SELECT consumer_id FROM consumer LIMIT 1;');

            if (consumers.rows.length > 0) {
                consumerId = consumers.rows[0].consumer_id;
                console.log(`Знайдено існуючого споживача з ID: ${consumerId}`);
            } else {
                 console.log('Споживача не знайдено. Створюємо нового...');
                 // Для цього треба створити ієрархію: region -> district -> power_group -> address -> consumer

                 // Мінімальний набір даних
                 const regionRes = await client.query("INSERT INTO region (name, type) VALUES ('Test Region', 'city') RETURNING region_id");
                 const regionId = regionRes.rows[0].region_id;

                 const districtRes = await client.query(`INSERT INTO district (region_id, name) VALUES (${regionId}, 'Test District') RETURNING district_id`);
                 const districtId = districtRes.rows[0].district_id;

                 const groupRes = await client.query(`INSERT INTO power_group (district_id, code) VALUES (${districtId}, 'GRP-001') RETURNING group_id`);
                 const groupId = groupRes.rows[0].group_id;

                 const addressRes = await client.query(`INSERT INTO address (district_id, group_id, street, house_number) VALUES (${districtId}, ${groupId}, 'Test St', '1') RETURNING address_id`);
                 const addressId = addressRes.rows[0].address_id;

                 const consumerRes = await client.query(`INSERT INTO consumer (address_id, consumer_type, email) VALUES (${addressId}, 'residential', 'test@example.com') RETURNING consumer_id`);
                 consumerId = consumerRes.rows[0].consumer_id;

                 console.log(`Створено нового споживача з ID: ${consumerId}`);
            }

            // 2. Вставити відгук
            const insertRes = await client.query(`
                INSERT INTO review (consumer_id, rating, comment, created_at)
                VALUES ($1, 5, 'Дуже задоволений!', NOW())
                RETURNING *;
            `, [consumerId]);

            console.log('Вставлено запис:', insertRes.rows[0]);

            console.log('\n--- Читання даних з review ---');
            const selectRes = await client.query('SELECT * FROM review;');
            console.log('Знайдено записів:', selectRes.rows);
        }

    } catch (e) {
        console.error('Помилка:', e);
    } finally {
        await client.end();
    }
}

main();