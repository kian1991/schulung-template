import { Hono } from 'hono'
import { sql } from "bun";

const app = new Hono()

// GET / - Health Check
app.get('/', (c) => c.text('Seal API is running! 🦭'))

// GET /seals - List all seals
app.get('/seals', async (c) => {
  try {
    const seals = await sql`SELECT * FROM seals`;
    return c.json(seals)
  } catch (error) {
    console.error(error)
    return c.json({ error: 'Database error' }, 500)
  }
})

// GET /seals/:id - Get one seal
app.get('/seals/:id', async (c) => {
  const id = c.req.param('id')
  try {
    const seal = await sql`SELECT * FROM seals WHERE id = ${id}`;
    if (seal.length === 0) return c.json({ error: 'Seal not found' }, 404)
    return c.json(seal[0])
  } catch (error) {
    return c.json({ error: 'Database error' }, 500)
  }
})

// POST /seals - Create a seal
app.post('/seals', async (c) => {
  const body = await c.req.json()
  try {
    const result = await sql`
      INSERT INTO seals (name, species, age, weight_kg, is_friendly)
      VALUES (${body.name}, ${body.species}, ${body.age}, ${body.weight_kg}, ${body.is_friendly})
      RETURNING *
    `
    return c.json(result[0], 201)
  } catch (error) {
    return c.json({ error: 'Failed to create seal' }, 500)
  }
})

export default {
  port: 3000,
  fetch: app.fetch,
}
