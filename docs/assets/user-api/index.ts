import { Hono } from 'hono'
import { MongoClient } from 'mongodb'

const app = new Hono()
const MONGO_URL = process.env.MONGO_URL || 'mongodb://localhost:27017'
const client = new MongoClient(MONGO_URL)

try {
  await client.connect()
  console.log('Connected to MongoDB')
} catch (e) {
  console.error('Failed to connect to MongoDB', e)
}

const db = client.db('user-db')
const users = db.collection('users')

// Helper to seed if empty
async function seed() {
  const count = await users.countDocuments()
  if (count === 0) {
    await users.insertMany([
      { name: "Kian", role: "Trainer" },
      { name: "Mia", role: "Student" },
      { name: "Tim", role: "Student" }
    ])
    console.log("Database seeded!")
  }
}
seed()

app.get('/', (c) => c.text('User API is running! 👤'))

app.get('/users', async (c) => {
  const allUsers = await users.find().toArray()
  return c.json(allUsers)
})

app.post('/users', async (c) => {
  const body = await c.req.json()
  const result = await users.insertOne(body)
  return c.json({ id: result.insertedId, ...body }, 201)
})

export default {
    port: 3001, 
    fetch: app.fetch 
}
