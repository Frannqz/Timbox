import express from 'express';
import client from '../database/db.js';

const router = express.Router();

router.get('/usuarios', async (req, res) => {
    try {
        const result = await client.query('SELECT * FROM usuarios');
        res.json(result.rows);
    } catch (err) {
        console.error('Error al obtener usuarios', err);
        res.status(500).send('Error al obtener usuarios');
    }
});

export default router;
