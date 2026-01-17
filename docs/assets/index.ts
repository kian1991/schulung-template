import { SQL } from 'bun';

const db = new SQL('mysql://root:root@localhost:3306/app_db');

async function main() {
  try {
    console.log('Successfully connected to MySQL!');

    const result = await db`SELECT 'Hello World' AS greeting;`;
    console.table(result);
  } catch (error) {
    console.error('Error:', error);
  }
}

main();
