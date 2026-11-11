const express = require('express');
const { Pool } = require('pg');
const { createClient } = require('redis');

const app = express();
app.use(express.json());

const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});
const redis = createClient({ url: `redis://${process.env.REDIS_HOST}:6379` });

app.get('/health', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    await redis.ping();
    res.json({ status: 'ok' });
  } catch (err) {
    res.status(503).json({ status: 'error' });
  }
});

app.get('/visits', async (req, res) => {
  res.json({ visits: await redis.incr('visits') });
});

app.get('/todos', async (req, res) => {
  const { rows } = await pool.query('SELECT * FROM todos ORDER BY id');
  res.json(rows);
});

app.post('/todos', async (req, res) => {
  if (!req.body.title) return res.status(400).json({ error: 'title is required' });
  const { rows } = await pool.query(
    'INSERT INTO todos (title) VALUES ($1) RETURNING *',
    [req.body.title]
  );
  res.status(201).json(rows[0]);
});

async function start() {
  await redis.connect();
  await pool.query(
    'CREATE TABLE IF NOT EXISTS todos (id SERIAL PRIMARY KEY, title TEXT NOT NULL)'
  );
  const server = app.listen(3000, () => console.log('API on 3000'));
  const stop = () => server.close(() => process.exit(0));
  process.on('SIGTERM', stop);
  process.on('SIGINT', stop);
}

start().catch((err) => { console.error(err); process.exit(1); });
