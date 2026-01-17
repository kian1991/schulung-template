import { SQL } from "bun";

// TODO: Passwort anpassen!
const db = new SQL("mysql://root:root@localhost:3306/app_db");

const term = process.argv[2];

if (!term) {
    console.error("Bitte Suchbegriff angeben!");
    console.log("Usage: bun run search.ts <begriff>");
    process.exit(1);
}

console.log(`Suche in der Meerwelt nach: "${term}"...\n`);

try {

    // Hier dein Code

} catch (err) {
    console.error("Fehler:", err);
}

await db.close();